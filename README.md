 Cómo ejecutar el proyecto
Herramientas utilizadas
Microsoft SQL Server
SQL Server Management Studio (SSMS)
Configuración inicial
Crear una base de datos llamada RetailData.

Importar los siguientes archivos CSV utilizando la opción:

Tasks → Import Flat File

transactions.csv
transaction_items.csv
stores.csv
products.csv
vendors.csv
store_promotions.csv
Verificar que las tablas fueron creadas correctamente.
Ajustes realizados después de la importación

Se agregaron las llaves primarias necesarias para mantener la integridad de los datos:

stores(store_id)
store_promotions(promo_id)
Ejecución

Los análisis fueron ejecutados directamente en SQL Server Management Studio mediante consultas SQL divididas en bloques:

Bloque 0 – Auditoría de calidad de datos

Incluye validaciones de:

Completitud
Consistencia
Unicidad
Validez
Integridad referencial
Frescura
Integridad temporal
Validación de experimentos A/B

Bloque 1 – Análisis de negocio

Incluye consultas relacionadas con:

Crecimiento de ventas
Productividad de tiendas
Clientes de lealtad
Rentabilidad por proveedor
Productos de baja rotación
Impacto de promociones
