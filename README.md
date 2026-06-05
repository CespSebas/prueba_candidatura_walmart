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
│   └── archivos csv
│
├──  BLOQUE 0: AUDITORÍA DE CALIDAD
│   ├── audit.py                        ← código reproducible
│   └── bloque0_auditoria.md            ← hallazgos y decisiones
│
├──  BLOQUE 1: QUERIES SQL
│   └── bloque1_queries.sql             ← 6 queries comentadas y validadas
│
├──  BLOQUE 2: MODELADO, ETL Y GOBERNANZA
│   ├── bloque2_decisiones.md           ← decisiones y justificaciones
│   └── bloque2_modelo.pdf              ← diagrama Star Schema
│
├──  BLOQUE 3: ANÁLISIS EXPLORATORIO Y A/B
│   ├── bloque3_analisis.ipynb          ← notebook ejecutado (código+resultados)
│   ├── bloque3_analisis.html           ← mismo notebook en HTML
│   ├── bloque3_analisis.md             ← versión narrativa (resumen)
│   └── bloque3_visualizaciones/        ← 5 gráficos (PNG)
│
├──  BLOQUE 4: FRAMEWORK DE KPIs
│   └── bloque4_kpi_framework.md        ← framework + North Star Metric
│
├──  BLOQUE 5: DASHBOARD Y PRESENTACIÓN
│   ├── bloque5_dashboard.html          ← dashboard interactivo funcional
│   ├── bloque5_powerbi_guia.md         ← guía + medidas DAX (.pbix/.twbx)
│   └── bloque5_presentacion.pdf        ← presentación ejecutiva (inglés, 5 slides)
│
└──  AUTOMATIZACIÓN Y EXPORTACIÓN
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

 Apoyo técnico y consultas:

Explicación de conceptos relacionados con calidad de datos, modelado dimensional, ETL y métricas de negocio.
Resolución de dudas sobre SQL Server, importación de archivos CSV y construcción de consultas SQL.

 Apoyo en propuestas de solución:

Sugerencias de enfoques para resolver los distintos bloques de la prueba.
Recomendaciones para estructurar consultas, validaciones y documentación.

 Documentación y presentación:

Apoyo en la redacción de explicaciones técnicas, comentarios en consultas SQL y organización del README.

### Validación del Analista

Apoyo brindado por IA	Validación realizada por el analista
Explicación de conceptos de SQL, calidad de datos y modelado dimensional	Verificación de resultados directamente en SQL Server
Sugerencias de consultas SQL y estructuras de análisis	Ajuste de consultas según la estructura real de las tablas importadas
Apoyo en la interpretación de errores de importación y tipos de datos	Corrección manual de problemas detectados durante la carga de los CSV
Apoyo en la redacción de documentación y comentarios	Interpretación de hallazgos y conclusiones de negocio
Supervisión y validación

Todas las consultas fueron ejecutadas sobre los datos reales del ejercicio.

Los resultados obtenidos fueron revisados manualmente para validar:

Calidad e integridad de los datos.
Consistencia de las métricas calculadas.
Cumplimiento de los requerimientos de cada bloque.
Coherencia de las conclusiones presentadas.
Ejemplos de uso
Explicación de errores de conversión de datos en SQL Server.
Apoyo en la construcción de consultas para auditoría de calidad de datos.
Apoyo en el diseño del modelo dimensional tipo Star Schema.

---

