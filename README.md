Prueba Tecnica — Data Analyst · Cadena Retail Multiformato (Centroamérica)
Análisis end-to-end sobre 6 CSV (174.880 transacciones, 542.015 líneas, 40 tiendas, 5 países, 18 meses).
Todos los resultados se calcularon ejecutando código real sobre los datos crudos; las cifras de los entregables están validadas, no estimadas.
Estructura del repositorio
prueba_tecnica_[nombre]/
├── README.md                      ← este archivo
├── data/                          ← (colocar aquí los 6 CSV originales)
│
├── audit.py                       ← Bloque 0: auditoría de calidad reproducible
├── bloque0_auditoria.md           ← Bloque 0: hallazgos y decisiones
├── bloque1_queries.sql            ← Bloque 1: 6 queries SQL comentadas y validadas
├── bloque2_decisiones.md          ← Bloque 2: modelado, ETL y gobernanza
├── bloque2_modelo.pdf             ← Bloque 2: diagrama Star Schema
├── bloque3_analisis.ipynb         ← Bloque 3: EDA + A/B (notebook ejecutado, código+resultados)
├── bloque3_analisis.html          ← Bloque 3: mismo notebook exportado a HTML
├── bloque3_analisis.md            ← Bloque 3: versión narrativa (resumen)
├── bloque3_visualizaciones/       ← Bloque 3: 5 gráficos (PNG)
├── bloque4_kpi_framework.md       ← Bloque 4: framework de KPIs + North Star
├── bloque5_dashboard.html         ← Bloque 5: dashboard operativo (interactivo, funcional)
├── bloque5_powerbi_guia.md        ← Bloque 5: guía + medidas DAX para armar el .pbix/.twbx
├── bloque5_presentacion.pdf       ← Bloque 5: presentación ejecutiva (inglés, 5 slides)
│
├── build_notebook.py              ← genera y ejecuta el notebook del Bloque 3
├── build_deck.py                  ← genera la presentación PDF
├── dashboard_data.json            ← agregados que alimentan el dashboard
└── dashboard_export/              ← agregados en CSV para reconstruir en Power BI/Tableau
Cómo reproducir
Requisitos: Python 3.10+ con pandas, duckdb, scipy, matplotlib, pdf2image.
bashpip install pandas duckdb scipy matplotlib pdf2image
Colocar los 6 CSV en ./data/.
AcciónComandoAuditoría de calidad (Bloque 0)python audit.py --data ./dataQueries SQL (Bloque 1)Ejecutar bloque1_queries.sql en DuckDB. Presentación (Bloque 5)python build_deck.pyDashboard (Bloque 5)Abrir bloque5_dashboard.html en cualquier navegador
Sobre el dashboard: se entrega como HTML autocontenido (datos embebidos, sin dependencias de licencia, se abre en cualquier equipo). Los agregados en dashboard_export/*.csv permiten reconstruir el mismo tablero en Power BI, Tableau o Looker importándolos como fuente; la capa de medidas equivale a las definiciones del bloque1_queries.sql.
Decisiones transversales (heredadas del Bloque 0)

Hallazgos principales

A/B test (dif-en-dif): la exhibición nueva genera +10% de GMV, p=0.004 — significativo. La comparación ingenua (−17%) era un artefacto del desbalance de grupos.
EXPRESS es la mejor apuesta de expansión: $1.057/m² (2,5x el hipermercado) y mayor crecimiento comparable (+11,6%).
$7,3M (15% del GMV) en riesgo por quiebres (techo), 76% en Electrónica+Hogar; no separable de demanda sin datos de inventario.
Retención de lealtad alta (~70%) pero ticket plano → la palanca es el gasto por visita.


Documentación de uso de IA
Este trabajo se desarrolló con asistencia de un modelo de IA (Claude) en un flujo colaborativo. Transparencia sobre el proceso:
Cómo se usó la IA

Exploración y código: se le pidió a la IA escribir y ejecutar el código de auditoría, las queries SQL y los análisis estadísticos (DuckDB/pandas/scipy) directamente sobre los CSV, iterando sobre los resultados reales.
Razonamiento analítico: la IA propuso el enfoque para cada bloque (p. ej. usar diferencia-en-diferencias al detectar el desbalance del A/B, o corregir la métrica de quiebres cuando el método ingenuo dio un valor imposible).

Qué generó la IA vs. qué validó/decidió el analista

Generado por IA: primeras versiones del código, queries, visualizaciones, textos y diseño de los entregables.
Validado por el analista: todas las cifras se obtuvieron ejecutando el código sobre los datos reales (no se aceptó ningún número “de memoria”). Se revisaron y cuestionaron los resultados — el caso más claro fue la Query 5 de quiebres, donde el primer resultado ($339M, 7x el GMV) se identificó como erróneo y se corrigió en dos pasos hasta una cifra defendible.
Decisiones de criterio: las reglas de negocio transversales (definición de GMV, exclusiones, ancla temporal, North Star Metric) se discutieron y acordaron explícitamente, no se delegaron a ciegas.

Prompts representativos

“Audita la calidad de los 6 CSV y dame evidencia y decisión por hallazgo.”
“El GMV perdido por quiebres da 7x el GMV total — eso es imposible, revisa la metodología.”
“Los grupos del A/B no están balanceados; resuélvelo con el método correcto.”
“Arma el dashboard y la presentación ejecutiva en inglés con cada recomendación respaldada por un número.”

El criterio de fondo (qué es correcto, qué es accionable, qué advertir) se mantuvo bajo revisión humana en cada bloque.
