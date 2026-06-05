# Bloque 2 — Modelado de Datos + Diseño de Pipeline

Diagrama del Star Schema: `bloque2\_modelo.pdf`.

## A. Modelo Dimensional (Star Schema)

El modelo usa **dos tablas de hechos a distinto grano** y cinco dimensiones conformadas. Soporta los cinco análisis pedidos (comp sales, GMROI, retención, productividad y promociones).

### Tablas de hechos

**`fact\_sales\_line`** — grano: **una línea de ítem por transacción** (la más fina; permite desagregar por producto/categoría).

* FKs: `date\_key`, `store\_key`, `product\_key`, `customer\_key`, `promo\_key`
* `transaction\_id` (dimensión degenerada, para reconstruir la canasta)
* Medidas: `quantity`, `unit\_price`, `line\_gmv` (=qty×price), `unit\_cost\_at\_sale`, `line\_cost` (=qty×cost), `was\_on\_promo`
* `status` (COMPLETED/RETURNED) — se filtra para GMV.

**`fact\_transaction\_header`** — grano: **una transacción**. Existe para conciliar el descuento de cabecera detectado en el Bloque 0.

* FKs: `date\_key`, `store\_key`, `customer\_key`
* Medidas: `total\_amount` (neto reportado), `payment\_method`, `loyalty\_card`, `header\_discount` (= Σlíneas − total\_amount, derivado en ETL)

### Dimensiones

* **`dim\_date`** — fecha, semana, mes, trimestre, año, día de semana, flag fin de semana.
* **`dim\_store`** (SCD2) — store, nombre, país, ciudad, formato, `size\_sqm`, región, `opening\_date`, `valid\_from`/`valid\_to`.
* **`dim\_product`** (SCD2) — ítem, nombre, marca, categoría, departamento, **+ atributos de proveedor desnormalizados** (`vendor\_name`, `vendor\_country`, `vendor\_tier`, `is\_shared\_catalog`).
* **`dim\_customer`** — `customer\_key`, `customer\_id`, cohorte, flags de lealtad. Incluye un miembro centinela `-1 = ANÓNIMO`.
* **`dim\_promotion`** — promo, variante (CONTROL/TREATMENT), tipo, ventana de fechas.

### Tres decisiones de diseño justificadas

**1. El 60% de transacciones sin `customer\_id` → miembro centinela, no NULL.**
En `dim\_customer` se crea una fila `customer\_key = -1` ("ANÓNIMO"). Toda transacción sin tarjeta apunta a esa clave. **Por qué:** evita FKs nulas (que rompen joins e inflan errores en BI), permite contar explícitamente "identificado vs anónimo" como segmento, y deja las cohortes de lealtad como un simple filtro `customer\_key <> -1`. Validado en Bloque 0: el NULL es 100% consistente con `loyalty\_card=FALSE`, así que el centinela es semánticamente correcto.

**2. Dos hechos a distinto grano para resolver la fuente de verdad del GMV.**
El Bloque 0 encontró que `total\_amount` < Σlíneas en 1% de tickets (descuento de cabecera, siempre negativo, \~7%). En vez de elegir una sola cifra y perder información, se modelan ambas: `fact\_sales\_line` da el GMV desagregable (fuente de verdad para análisis de producto/categoría) y `fact\_transaction\_header` preserva el neto real y expone `header\_discount` como medida. **Por qué:** un solo número escondería el descuento; con dos hechos, finanzas concilia y comercial analiza, sin discrepancias inexplicables (cierra el caso de gobernanza 2C).

**3. SCD Type 2 en `dim\_store` y `dim\_product` (+ costo en el hecho).**
Las tiendas pueden remodelarse (cambia `size\_sqm`/formato) y el costo de producto cambia en el tiempo. Si se sobrescribe, el comp sales y el GMROI histórico quedan mal atribuidos. Solución: SCD2 para conservar la versión vigente en cada fecha, y además **`unit\_cost\_at\_sale` se materializa en `fact\_sales\_line`** (el costo del momento de la venta), de modo que el margen histórico es exacto aunque el costo actual del producto cambie. **Por qué:** comp sales y GMROI son métricas históricas; deben usar el atributo vigente *en su momento*, no el actual.

\---

## B. Diseño del Pipeline ETL/ELT

**¿Tiendas que reportan con hasta 2 horas de retraso?**
Patrón de **ventana de llegada tardía (late-arriving data)**: el pipeline no cierra un día hasta T+2–3h sobre la medianoche local de cada país (ojo: 5 husos/países). Operativamente, cargas *micro-batch* cada hora a una zona *staging* y un proceso de "cierre de día" que re-procesa las últimas 48h para capturar rezagados. El dashboard marca el último día como "preliminar" hasta el cierre.

**¿Cómo detectar que una tienda dejó de enviar datos?**
Monitor de **frescura por tienda** (deriva del Bloque 0 #8): para cada tienda se conoce su cadencia esperada (vende todos los días). Una alerta se dispara si una tienda activa no reporta ninguna transacción en > 24h (o > su patrón normal, p. ej. excluyendo su día de cierre). Se implementa como un job que compara `MAX(transaction\_date)` por tienda contra el reloj y notifica al data owner.

**¿Cargas incrementales sin duplicar?**

* Extracción incremental por *watermark* (`transaction\_date` o un `loaded\_at`), no recarga completa.
* **Idempotencia con MERGE/UPSERT** por clave natural (`transaction\_id`, `transaction\_item\_id`), que en el Bloque 0 se confirmó única. Si llega un registro ya presente, se actualiza en vez de insertar → reprocesar la ventana de 48h nunca duplica.

**¿Frecuencia del pipeline si el dashboard necesita refresh diario?**
Micro-batch **horario** para datos preliminares + un **cierre diario** (una vez pasada la ventana de tardíos de todos los husos, \~03:00 CR). El dashboard se refresca con el cierre diario; el header de "hoy" se alimenta del horario y se marca preliminar. No se justifica streaming en tiempo real para un dashboard diario.

\---

## C. Gobernanza

**¿Cómo proteger `customer\_id` (privacidad)?**

* `customer\_id` ya es un identificador seudónimo (no PII directa), pero se trata como dato sensible: **tokenización/hashing** del ID crudo en la capa de staging, acceso a la tabla de mapeo restringido por roles (RBAC), y enmascaramiento dinámico en BI para roles que no requieren identificar al cliente. Los análisis de cohorte funcionan con el token, sin exponer identidad. Cumplimiento alineado a normativa local de datos personales de cada país.

**¿Quién debería ser el data owner de la tabla de transacciones?**
El **área de Operaciones/Ventas Retail** como *business owner* (define qué significa una venta válida, reglas de negocio) y el equipo de **Data Engineering** como *technical owner/custodio* (SLA, calidad, pipeline). El owner de negocio aprueba cambios de definición; el técnico garantiza disponibilidad e integridad. Es un modelo de doble propiedad (negocio + técnico) estándar en data governance.

**Si dos reportes muestran GMV distinto para la misma tienda y día — ¿proceso para resolverlo?**

1. **Reproducir** ambos números con la query exacta de cada reporte.
2. **Diagnosticar la definición:** verificar si uno usa `total\_amount` y otro Σlíneas (la causa más probable, dado el hallazgo del Bloque 0), si difieren en el filtro de `status` (incluir/excluir RETURNED), o en zona horaria del corte de día.
3. **Aplicar la fuente de verdad única** (GMV = Σlíneas sobre COMPLETED) y certificar una sola métrica en una **capa semántica** (un solo lugar donde "GMV" se define), para que ningún reporte la recalcule por su cuenta.
4. **Documentar** la definición certificada en el catálogo de datos y deprecar la métrica divergente.

La raíz de este problema es justamente lo que el modelo de dos hechos + capa semántica previene: una métrica, una definición, un dueño.

