# Prueba Técnica – Data Analyst Retail Multiformato

## Descripción

Análisis de datos de una cadena retail multiformato en Centroamérica utilizando SQL Server y archivos CSV.
El dataset incluye información de:

* Transacciones
* Detalle de transacciones
* Tiendas
* Productos
* Proveedores
* Promociones

El objetivo fue realizar auditoría de calidad de datos, análisis de negocio, diseño dimensional, propuesta de ETL, diseño de KPIs, análisis exploratorio con experimentación A/B, y un dashboard con presentación ejecutiva.

## Estructura del repositorio

```
prueba_tecnica/
│
├── data/
│   ├── transactions.csv
│   ├── transaction_items.csv
│   ├── stores.csv
│   ├── products.csv
│   ├── vendors.csv
│   └── store_promotions.csv
│
├── sql/
│   ├── bloque0_auditoria.sql
│   └── bloque1_analisis.sql
│
├── documentacion/
│   ├── bloque0_auditoria.md
│   ├── bloque2_decisiones.md
│   ├── bloque2_modelo.pdf
│   ├── bloque3_analisis.ipynb
│   ├── bloque3_analisis.html
│   ├── bloque3_visualizaciones/
│   ├── bloque4_kpi_framework.md
│   ├── bloque5_dashboard.html
│   ├── bloque5_powerbi_guia.md
│   └── bloque5_presentacion.pdf
│
├── scripts/
│   ├── audit.py
│   ├── build_notebook.py
│   ├── build_deck.py
│   └── dashboard_export/        (agregados CSV para Power BI / Tableau)
│
└── README.md
```

## Herramientas utilizadas

* Microsoft SQL Server
* SQL Server Management Studio (SSMS)
* Python (pandas, DuckDB, scipy, matplotlib) — Bloque 3: análisis exploratorio y experimentación A/B
* Jupyter Notebook — Bloque 3 (`bloque3_analisis.ipynb`)
* Draw.io / diagramación — modelo dimensional (`bloque2_modelo.pdf`)
* Microsoft PowerPoint / PDF — presentación ejecutiva

## Cómo reproducir el análisis

### 1. Crear la base de datos

```sql
CREATE DATABASE RetailData;
```

### 2. Importar los archivos CSV

En SQL Server Management Studio: `Tasks → Import Flat File`. Importar:

* transactions.csv
* transaction_items.csv
* stores.csv
* products.csv
* vendors.csv
* store_promotions.csv

### 3. Configurar llaves primarias

Ejecutar las instrucciones incluidas al inicio de `sql/bloque0_auditoria.sql` (sección 0: llaves primarias e índices).

### 4. Ejecutar los análisis

**Bloque 0 — Auditoría de calidad**

```
sql/bloque0_auditoria.sql
```

Validaciones realizadas:

* Completitud
* Consistencia
* Unicidad
* Validez
* Integridad referencial
* Frescura
* Integridad temporal
* Experimentos A/B

**Bloque 1 — Análisis de negocio**

```
sql/bloque1_analisis.sql
```

Análisis realizados:

* Crecimiento de ventas comparables (comp sales)
* Productividad de tiendas (GMV por m²)
* Clientes de lealtad (cohortes de retención)
* Rentabilidad por proveedor (GMROI)
* Productos de baja rotación / posibles quiebres
* Impacto de promociones

### 5. Bloque 2 — Modelado de datos y diseño de pipeline

Documentación en `documentacion/`:

* `bloque2_decisiones.md` — modelo dimensional (star schema con dos hechos), decisiones de diseño, diseño de pipeline ETL y gobernanza.
* `bloque2_modelo.pdf` — diagrama del modelo dimensional.

### 6. Bloque 3 — Análisis exploratorio y experimentación

`documentacion/bloque3_analisis.ipynb` (notebook ejecutado, con código, resultados y gráficos) y su versión `bloque3_analisis.html`.
Para reejecutarlo: colocar los 6 CSV en `./data/` y correr el notebook (requiere `pandas`, `duckdb`, `scipy`, `matplotlib`).
Visualizaciones exportadas en `documentacion/bloque3_visualizaciones/`. Incluye el A/B test resuelto por diferencia-en-diferencias.

### 7. Bloque 4 — Diseño de KPIs

`documentacion/bloque4_kpi_framework.md` — 8 KPIs sobre tres dimensiones, indicadores adelantados, un KPI compuesto y la North Star Metric.

### 8. Bloque 5 — Dashboard y presentación ejecutiva

* `documentacion/bloque5_dashboard.html` — dashboard operativo interactivo (se abre en el navegador).
* `documentacion/bloque5_powerbi_guia.md` — guía con medidas DAX para reconstruirlo en Power BI / Tableau a partir de `scripts/dashboard_export/`.
* `documentacion/bloque5_presentacion.pdf` — presentación ejecutiva en inglés (5 slides) para el VP de Operaciones.

## Hallazgos principales

1. **A/B test (diferencia-en-diferencias):** la nueva exhibición genera **+10% de GMV** (p=0.004, significativo). La comparación ingenua (−17%) era un artefacto del desbalance de los grupos.
2. **EXPRESS es la mejor apuesta de expansión:** $1,057/m² (2.5× el hipermercado) y mayor crecimiento comparable (+11.6%).
3. **$7.3M (15% del GMV) en riesgo por quiebres** (techo), 76% en Electrónica + Hogar; no separable de demanda sin datos de inventario.
4. **Calidad de datos:** 60% de tx sin customer_id (por diseño), descuento de cabecera en 1% de tickets, 5 proveedores fantasma, y TIENDA_037 marcada por múltiples anomalías.

## Documentación de uso de IA

Este trabajo se apoyó en un asistente de IA bajo revisión humana en cada bloque.

* **Generado con IA:** primeras versiones del código SQL/Python, queries, visualizaciones, textos y el diseño de los entregables.
* **Validado por el analista:** todas las cifras se obtuvieron ejecutando el código sobre los datos reales (ningún número "de memoria"). El caso más claro fue la detección de quiebres, cuyo primer resultado ($339M, 7× el GMV) se identificó como erróneo y se corrigió hasta una cifra defendible ($7.3M).
* **Decisiones de criterio:** las reglas transversales (definición de GMV, exclusiones, ancla temporal, North Star Metric) y la interpretación de negocio se decidieron y revisaron manualmente.

Prompts representativos: *"audita la calidad de los 6 CSV con evidencia y decisión por hallazgo"*, *"el GMV perdido da 7× el total, revisa la metodología"*, *"los grupos del A/B no están balanceados, resuélvelo con el método correcto"*.
