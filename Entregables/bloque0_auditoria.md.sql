CREATE DATABASE RetailData;
GO

USE RetailData;
GO

DROP TABLE IF EXISTS DetalleTransaccion;
DROP TABLE IF EXISTS PromocionesTienda;
DROP TABLE IF EXISTS Transacciones;
DROP TABLE IF EXISTS Productos;
DROP TABLE IF EXISTS Tiendas;
DROP TABLE IF EXISTS Proveedores;

 SELECT TOP 20 cost
FROM products;

SELECT *
FROM products
WHERE TRY_CAST(cost AS DECIMAL(18,2)) IS NULL
AND cost IS NOT NULL;

SELECT *
FROM vendors

ALTER TABLE stores
ADD CONSTRAINT PK_stores
PRIMARY KEY (store_id);

ALTER TABLE store_promotions
ADD promo_id INT IDENTITY(1,1);

ALTER TABLE store_promotions
ADD CONSTRAINT PK_store_promotions
PRIMARY KEY (promo_id);

---------------------------
-- Partiendo del hecho de que la importaciones de los archivos csv estan correctas, verifico el total de los datos con contador. 
---------------------------

SELECT COUNT(*) AS TotalTransacciones FROM transactions;
SELECT COUNT(*) AS TotalItems FROM transaction_items;
SELECT COUNT(*) AS TotalTiendas FROM stores;
SELECT COUNT(*) AS TotalProductos FROM products;
SELECT COUNT(*) AS TotalProveedores FROM vendors;
SELECT COUNT(*) AS TotalPromociones FROM store_promotions;
---------------------------
-- Bloqueo 0
---------------------------

SELECT
    COUNT(*) AS TransaccionesSinCliente,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM transactions) AS DECIMAL(10,2)) AS Porcentaje
FROM transactions
WHERE customer_id IS NULL;

-- Completitud -- tiene un porcentaje de 59.8%

SELECT *
FROM transactions
WHERE customer_id IS NULL
AND loyalty_card = 1;

-- no se encontraron transacciones con customer_id nulo y loyalty_card = TRUE

-- Consistencia -- tiene un total de 1745 transacciones extra;as 

WITH detalle AS (
    SELECT
        transaction_id, -- calculo de los items 
        SUM(
            TRY_CAST(quantity AS DECIMAL(18,2))
            * TRY_CAST(unit_price AS DECIMAL(18,2))
        ) AS total_detalle
    FROM transaction_items
    GROUP BY transaction_id
)
SELECT
    COUNT(*) AS transacciones_inconsistentes  -- comparacion
FROM transactions t
INNER JOIN detalle d
    ON t.transaction_id = d.transaction_id
WHERE ABS(
        TRY_CAST(t.total_amount AS DECIMAL(18,2))
        - d.total_detalle
      ) > 0.01;


-- Unicidad -- no existen transacciones duplicadas en el db

SELECT COUNT(*) AS transacciones_duplicadas
FROM (
    SELECT transaction_id
    FROM transactions
    GROUP BY transaction_id
    HAVING COUNT(*) > 1
)t;

-- Validez

SELECT COUNT(*)
FROM transactions
WHERE TRY_CAST(total_amount AS DECIMAL(18,2)) <= 0;

--- Existen 3 resultados de total negativos

SELECT COUNT(*)
FROM transaction_items
WHERE TRY_CAST(unit_price AS DECIMAL(18,2)) = 0--1
AND was_on_promo = 'FALSE';

--- Hay 231 resultados en el apartado de validez  con el precio unitario en 0
-- y la promo falsa

/*
Integridad referencial 
*/

SELECT
    t.store_id,
    COUNT(*) AS cantidad
FROM transactions t
LEFT JOIN stores s
    ON t.store_id = s.store_id
WHERE s.store_id IS NULL
GROUP BY t.store_id; -- En todas las transacciones estan registradas las tiendas

SELECT
    p.vendor_id,
    COUNT(*) AS cantidad
FROM products p
LEFT JOIN vendors v
    ON p.vendor_id = v.vendor_id
WHERE v.vendor_id IS NULL
GROUP BY p.vendor_id;   --5, hay 5 productos sin proveedor 


-- Frescura -- no existen transacciones duplicadas en el db

WITH fechas AS (  --Tabla temp
    SELECT DISTINCT
        store_id,
        transaction_date
    FROM transactions
),
saltos AS (  --Tabla temp
    SELECT
        store_id,
        transaction_date,
        LAG(transaction_date) OVER(  -- con ayuda de lag podemos comparar junto con el dato anterior en este caso la fecha
            PARTITION BY store_id
            ORDER BY transaction_date
        ) AS fecha_anterior
    FROM fechas
)
SELECT
    store_id,
    fecha_anterior,
    transaction_date,
    DATEDIFF(DAY, fecha_anterior, transaction_date) AS dias_gap  -- muestra el resultado en base a los dias que tenga mas tiempo de los mismos entre si
FROM saltos
WHERE DATEDIFF(DAY, fecha_anterior, transaction_date) > 1
ORDER BY dias_gap DESC;

-- Integridad Temporal -- nos ayudan a descartar errores sencillos de resolver con simples consultas

SELECT
    t.transaction_id,
    t.store_id,
    t.transaction_date,
    s.opening_date
FROM transactions t
INNER JOIN stores s
    ON t.store_id = s.store_id
WHERE t.transaction_date < s.opening_date;  -- Todas son la tienda TIENDA_037, EN GUATEMALA 

-- A/B Test --  nos ayuda a identificar a que grupo pertenecen para comporarlas o su analisis  

 SELECT
    store_id,
    promo_name,
    COUNT(DISTINCT variant) AS variantes
FROM store_promotions
GROUP BY
    store_id,
    promo_name
HAVING COUNT(DISTINCT variant) > 1;

---------------------------
-- Bloqueo 1
---------------------------


-- ============================================================================
-- QUERY 1 — VENTAS COMPARABLES (COMP SALES, YoY)
-- Comparable = tienda abierta antes de 2024-01-01 (operó en ambos períodos).
-- Comparación apples-to-apples: H1-2025 vs H1-2024 (mismo semestre).
-- ============================================================================
WITH sales AS (                                     -- GMV nivel línea, solo ventas completadas
    SELECT t.store_id, t.transaction_date,
           ti.quantity * ti.unit_price AS line_gmv
    FROM transactions t
    JOIN transaction_items ti ON ti.transaction_id = t.transaction_id
    WHERE t.status = 'COMPLETED'
),
comparable_stores AS (                              -- abiertas antes del período base
    SELECT store_id FROM stores WHERE opening_date < DATE '2024-01-01'
),
store_yoy AS (                                      -- GMV por tienda en cada semestre
    SELECT s.store_id, st.country, st.format,
           SUM(CASE WHEN s.transaction_date BETWEEN DATE '2024-01-01' AND DATE '2024-06-30'
                    THEN s.line_gmv ELSE 0 END) AS gmv_prior,
           SUM(CASE WHEN s.transaction_date BETWEEN DATE '2025-01-01' AND DATE '2025-06-30'
                    THEN s.line_gmv ELSE 0 END) AS gmv_current
    FROM sales s
    JOIN comparable_stores c ON c.store_id = s.store_id
    JOIN stores st           ON st.store_id = s.store_id
    GROUP BY s.store_id, st.country, st.format
)
SELECT country, format, store_id,
       ROUND(gmv_prior, 2)   AS gmv_anio_anterior,
       ROUND(gmv_current, 2) AS gmv_anio_actual,
       ROUND(100.0 * (gmv_current - gmv_prior) / NULLIF(gmv_prior, 0), 1) AS comp_sales_growth_pct,
       RANK() OVER (PARTITION BY format
                    ORDER BY (gmv_current - gmv_prior) / NULLIF(gmv_prior, 0) DESC) AS rank_en_formato
FROM store_yoy
WHERE gmv_prior > 0
ORDER BY format, rank_en_formato;
 
-- QUERY 1b — Rollup país × formato (mismo CTE store_yoy, agregado)
-- SELECT country, format,
--        ROUND(SUM(gmv_current),2) AS gmv_actual,
--        ROUND(SUM(gmv_prior),2)   AS gmv_anterior,
--        ROUND(100.0*(SUM(gmv_current)-SUM(gmv_prior))/NULLIF(SUM(gmv_prior),0),1) AS comp_growth_pct
-- FROM store_yoy GROUP BY country, format ORDER BY country, format;
 