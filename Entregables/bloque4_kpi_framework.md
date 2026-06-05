# Bloque 4 — Framework de KPIs

Marco de 8 KPIs sobre tres dimensiones (productividad de tienda, experiencia/lealtad del cliente, desempeño de proveedor), con al menos un indicador **adelantado** (leading), un KPI **compuesto** y una **North Star Metric**. Los *baselines* son las cifras reales calculadas en los Bloques 1 y 3.

## North Star Metric: **GMV por m² de la red**

**Definición:** GMV total de la cadena ÷ superficie total operativa (m²), medido mensual.
**Baseline (período completo):** EXPRESS $1.057/m² · DESCUENTO $588 · SUPERMERCADO $517 · HIPERMERCADO $412.

**Por qué esta y no el GMV total:** el GMV crudo es una métrica de vanidad — crece solo con abrir tiendas, sin decir si el capital se usa bien. GMV/m² obliga a equilibrar **ingreso y eficiencia del recurso más caro y escaso del retail: el espacio**. Es la métrica que cambió nuestra conclusión estratégica más importante (EXPRESS rinde 2,5x el HIPERMERCADO por metro). Además, **todas las demás dimensiones escalan hacia ella**: la productividad la compone directamente, la disponibilidad de proveedor evita ventas perdidas por metro, y la lealtad sube el tráfico por metro. Una sola métrica que no se puede inflar artificialmente y que alinea expansión, surtido y operación.
*(Alternativa considerada: gasto anual por cliente leal — más centrada en cliente, pero no captura la eficiencia de capital que distingue a esta cadena multiformato.)*

---

## Tabla de KPIs

| # | KPI | Dimensión | Tipo | Fórmula | Baseline real | Meta |
|---|-----|-----------|------|---------|---------------|------|
| 1 | **GMV/m²** | Productividad tienda | Lagging | GMV ÷ size_sqm | $73–$209 según formato (Q2-25) | Cada tienda > p25 de su formato |
| 2 | **Comp Sales Growth** | Productividad tienda | Lagging | (GMV_actual − GMV_año_ant)/GMV_año_ant en comparables | +4,8% a +11,6% por formato | ≥ mediana del formato |
| 3 | **Tasa de captura de lealtad** | Cliente | **Leading** | tx con tarjeta ÷ tx totales | 40% (70.248/174.880) | +5 pp a 12 meses |
| 4 | **Retención de lealtad m6** | Cliente | Lagging | % de cohorte activa en mes 6 | ~70% | Mantener ≥70% |
| 5 | **Gasto por visita del cliente leal** | Cliente | Lagging | GMV leal ÷ nº visitas leales | ~$280 (plano) | +5% (palanca del Bloque 3) |
| 6 | **GMROI relativo** | Proveedor | Lagging | (Margen/Costo), ranking percentil por categoría | global 0,61; 117/126 combos <1 | Foco en cuartil inferior |
| 7 | **Tasa de quiebre (días sin venta anómalos)** | Proveedor/Operación | **Leading** | días-ítem con gap > 3× cadencia ÷ días-ítem activos | $7,3M techo (15% GMV) | Reducir 20% el GMV en riesgo |
| 8 | **Índice de Salud de Tienda** | Compuesto | **Composite** | ver abajo | — | ≥70/100 todas las tiendas |

---

## Detalle de los indicadores especiales

### Indicador adelantado #3 — Tasa de captura de lealtad *(leading)*
Es *adelantado* porque las altas de lealtad de **hoy** alimentan las cohortes retenidas de **mañana**: predice el GMV futuro de clientes identificados antes de que ocurra. Hoy solo el 40% de las transacciones se asocian a un cliente; subir esa captura es el motor de crecimiento del valor de cliente a largo plazo.

### Indicador adelantado #7 — Tasa de quiebre *(leading)*
Un quiebre precede a la venta perdida: detectar gaps anómalos hoy permite actuar antes de que el GMV caiga. Se define relativo a la cadencia propia de cada ítem (metodología validada en Query 5), no en días absolutos, para no marcar baja rotación natural como quiebre.

### KPI compuesto #8 — Índice de Salud de Tienda *(composite, 0–100)*
Un solo número para rankear y triar las 40 tiendas, combinando tres señales normalizadas a percentil dentro del formato:

```
Salud = 0,45 × percentil(GMV/m²)        # productividad: el resultado que importa
      + 0,35 × percentil(Comp Growth)    # trayectoria: ¿mejora o se estanca?
      + 0,20 × (1 − tasa_quiebre_norm)   # ejecución: ¿pierde ventas evitables?
```

**Justificación de pesos:** la productividad (0,45) es el resultado de negocio central; el crecimiento (0,35) distingue una tienda buena-pero-estancada de una en ascenso; la disponibilidad (0,20) es el factor operativo accionable a corto plazo. Se calcula por formato (no se compara un EXPRESS contra un HIPERMERCADO, que tienen economías distintas). Permite al VP de Operaciones ver de un vistazo qué tiendas necesitan intervención sin mirar cinco tableros.

---

## Cómo se conecta con la North Star
Los KPIs 1–2 son los componentes directos de GMV/m². Los KPIs 3–5 lo alimentan vía tráfico y gasto de clientes leales. Los KPIs 6–7 lo protegen evitando margen y ventas perdidas. El KPI 8 lo operacionaliza tienda por tienda. Así, mover cualquier KPI en la dirección correcta empuja la North Star, sin incentivos contradictorios.
