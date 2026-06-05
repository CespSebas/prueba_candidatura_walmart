# Prueba Técnica — Data Analyst
**Cadena Retail Multiformato (Centroamérica)**

---

## Resumen Ejecutivo

Análisis end-to-end sobre **6 CSV** con:
- **174.880 transacciones** | **542.015 líneas** de datos
- **40 tiendas** | **5 países** | **18 meses**

✓ Todos los resultados se calcularon ejecutando código real sobre los datos crudos  
✓ Las cifras de los entregables están validadas, no estimadas

---

## Hallazgos Principales

| Insight | Dato |
|---------|------|
| **A/B test (dif-en-dif)** | Exhibición nueva genera **+10% GMV**, p=0.004 ✓ Significativo |
| **Mejor expansión** | EXPRESS: **$1.057/m²** (2,5x hipermercado) con **+11,6%** crecimiento |
| **Riesgo por quiebres** | **$7,3M (15% del GMV)** en riesgo; 76% en Electrónica+Hogar |
| **Retención de lealtad** | ~70% (alta) pero ticket plano → palanca: gasto/visita |

---

## Estructura del Repositorio

```
prueba_tecnica_[nombre]/
│
├── README.md                           ← este archivo
│
├── data/
│   └── (colocar aquí los 6 CSV originales)
│
├── 📋 BLOQUE 0: AUDITORÍA DE CALIDAD
│   ├── audit.py                        ← código reproducible
│   └── bloque0_auditoria.md            ← hallazgos y decisiones
│
├── 🔍 BLOQUE 1: QUERIES SQL
│   └── bloque1_queries.sql             ← 6 queries comentadas y validadas
│
├── 📐 BLOQUE 2: MODELADO, ETL Y GOBERNANZA
│   ├── bloque2_decisiones.md           ← decisiones y justificaciones
│   └── bloque2_modelo.pdf              ← diagrama Star Schema
│
├── 📊 BLOQUE 3: ANÁLISIS EXPLORATORIO Y A/B
│   ├── bloque3_analisis.ipynb          ← notebook ejecutado (código+resultados)
│   ├── bloque3_analisis.html           ← mismo notebook en HTML
│   ├── bloque3_analisis.md             ← versión narrativa (resumen)
│   └── bloque3_visualizaciones/        ← 5 gráficos (PNG)
│
├── 📈 BLOQUE 4: FRAMEWORK DE KPIs
│   └── bloque4_kpi_framework.md        ← framework + North Star Metric
│
├── 📱 BLOQUE 5: DASHBOARD Y PRESENTACIÓN
│   ├── bloque5_dashboard.html          ← dashboard interactivo funcional
│   ├── bloque5_powerbi_guia.md         ← guía + medidas DAX (.pbix/.twbx)
│   └── bloque5_presentacion.pdf        ← presentación ejecutiva (inglés, 5 slides)
│
└── 🔧 AUTOMATIZACIÓN Y EXPORTACIÓN
    ├── build_notebook.py               ← genera y ejecuta Bloque 3
    ├── build_deck.py                   ← genera presentación PDF
    ├── dashboard_data.json             ← agregados (alimentan dashboard)
    └── dashboard_export/               ← CSV para reconstruir en Power BI/Tableau
```

---

## Cómo Reproducir

### Requisitos

Python 3.10+ con dependencias:

```bash
pip install pandas duckdb scipy matplotlib pdf2image
```

### Pasos

| Paso | Acción | Comando |
|------|--------|---------|
| 1 | Colocar los 6 CSV en `./data/` | — |
| 2 | Auditoría de calidad (Bloque 0) | `python audit.py --data ./data` |
| 3 | Queries SQL (Bloque 1) | Ejecutar `bloque1_queries.sql` en DuckDB |
| 4 | Dashboard interactivo (Bloque 5) | `python build_deck.py` |
| 5 | Presentación ejecutiva (Bloque 5) | Ver `bloque5_presentacion.pdf` |

### Notas sobre el Dashboard

- **Formato**: HTML autocontenido (datos embebidos, sin dependencias de licencia)
- **Portabilidad**: Se abre en cualquier equipo sin instalación adicional
- **Reconstrucción**: Los agregados en `dashboard_export/*.csv` permiten reconstruir en Power BI o Tableau siguiendo la guía `bloque5_powerbi_guia.md`

---

## Decisiones Transversales

### Calidad de Datos (Bloque 0)

Todas las decisiones de limpieza, exclusión y normalización están documentadas en `bloque0_auditoria.md` con:
- Evidencia del hallazgo
- Impacto en el análisis
- Regla aplicada

### Gobernanza (Bloque 2)

- **Definición única de GMV** (aplicada en todos los análisis)
- **Exclusiones explícitas** (justificadas por negocio)
- **Ancla temporal** (período base consistente)
- **North Star Metric** (derivada del framework de KPIs)

---

## Documentación de Uso de IA

Este trabajo se desarrolló con asistencia de un modelo de IA (**Claude**) en un flujo colaborativo.

### Cómo se Usó la IA

✅ **Exploración y código**: Se pidió a la IA escribir y ejecutar el código de auditoría, queries SQL y análisis estadísticos (DuckDB/pandas/scipy) directamente sobre los CSV, iterando sobre resultados.

✅ **Razonamiento analítico**: La IA propuso enfoques para cada bloque:
- Usar diferencia-en-diferencias al detectar desbalance del A/B
- Corregir métrica de quiebres cuando el método ingenuo daba resultados imposibles
- Diseñar visualizaciones que respalden conclusiones

✅ **Automatización y formato**: Generación de notebooks, dashboards, PDF y exportación de datos.

### Validación del Analista

| Generado por IA | Validado/Decidido por Analista |
|---|---|
| Primeras versiones del código | Todas las cifras ejecutadas sobre datos reales |
| Queries SQL | Resultados revisados y cuestionados |
| Visualizaciones | Números de negocio no delegados a ciegas |
| Textos y diseño | Decisiones de criterio: GMV, exclusiones, North Star |

**Criterio de fondo** (qué es correcto, qué es accionable, qué advertir) se mantuvo bajo revisión humana en cada bloque.

### Prompts Representativos

```
"Audita la calidad de los 6 CSV y dame evidencia y decisión por hallazgo."
"El GMV perdido por quiebres da 7x el GMV total — eso es imposible, revisa la metodología."
"Los grupos del A/B no están balanceados; resuélvelo con el método correcto."
"Arma el dashboard y la presentación ejecutiva en inglés con cada recomendación respaldada por un número."
```

---

## Navegación Rápida

- 📖 **Comienza aquí**: Lee `bloque0_auditoria.md` (contexto de datos)
- 🔍 **Profundiza**: Abre `bloque3_analisis.html` en el navegador
- 📊 **Dashboard**: Abre `bloque5_dashboard.html` en el navegador
- 📑 **Presentación**: Descarga `bloque5_presentacion.pdf`
- 🛠️ **Reconstruye**: Sigue `bloque5_powerbi_guia.md` para Power BI / Tableau

---

**Versión**: v1.0 | **Último update**: 2024 | **Desarrollado con Claude**
