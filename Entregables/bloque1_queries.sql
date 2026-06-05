USE RetailData;
GO

/*
Objetivo:
Comparar las ventas de cada tienda entre 2024 y 2025
para identificar cuáles crecieron y cuáles disminuyeron.
*/

SELECT
    s.store_id,
    s.store_name,

    -- Ventas acumuladas durante 2024
    SUM(
        CASE
            WHEN YEAR(t.transaction_date) = 2024
            THEN TRY_CAST(ti.quantity AS DECIMAL(18,2))
                 * TRY_CAST(ti.unit_price AS DECIMAL(18,2))
            ELSE 0
        END
    ) AS ventas_2024,

    -- Ventas acumuladas durante 2025
    SUM(
        CASE
            WHEN YEAR(t.transaction_date) = 2025
            THEN TRY_CAST(ti.quantity AS DECIMAL(18,2))
                 * TRY_CAST(ti.unit_price AS DECIMAL(18,2))
            ELSE 0
        END
    ) AS ventas_2025

FROM transactions t

INNER JOIN transaction_items ti
    ON t.transaction_id = ti.transaction_id

INNER JOIN stores s
    ON t.store_id = s.store_id

-- Solo se consideran ventas completadas
WHERE t.status = 'COMPLETED'

GROUP BY
    s.store_id,
    s.store_name

-- Mostrar primero las tiendas con más ventas en 2025
ORDER BY ventas_2025 DESC;


/*
Objetivo:
Determinar qué tan eficiente es cada tienda
utilizando el espacio físico disponible.
*/

SELECT
    s.store_id,
    s.store_name,
    s.format,
    s.size_sqm,

    -- Ventas totales de la tienda
    SUM(
        TRY_CAST(ti.quantity AS DECIMAL(18,2))
        *
        TRY_CAST(ti.unit_price AS DECIMAL(18,2))
    ) AS ventas,

    -- Ventas generadas por cada metro cuadrado
    SUM(
        TRY_CAST(ti.quantity AS DECIMAL(18,2))
        *
        TRY_CAST(ti.unit_price AS DECIMAL(18,2))
    ) / NULLIF(s.size_sqm,0) AS ventas_por_metro

FROM stores s

INNER JOIN transactions t
    ON s.store_id = t.store_id

INNER JOIN transaction_items ti
    ON t.transaction_id = ti.transaction_id

WHERE t.status = 'COMPLETED'

GROUP BY
    s.store_id,
    s.store_name,
    s.format,
    s.size_sqm

-- Las tiendas más eficientes aparecerán primero
ORDER BY ventas_por_metro DESC;

/*
Objetivo:
Identificar los clientes afiliados al programa de lealtad
que generan más compras e ingresos.
*/

SELECT
    customer_id,

    -- Cantidad de transacciones realizadas
    COUNT(transaction_id) AS compras,

    -- Dinero total gastado por el cliente
    SUM(
        TRY_CAST(total_amount AS DECIMAL(18,2))
    ) AS gasto_total

FROM transactions

WHERE loyalty_card = 1
AND customer_id IS NOT NULL
AND status = 'COMPLETED'

GROUP BY customer_id

-- Clientes que más dinero gastan
ORDER BY gasto_total DESC;


/*
Objetivo:
Comparar ingresos y costos para determinar
qué proveedores y categorías generan mayor utilidad.
*/

SELECT
    v.vendor_name,
    p.category,

    -- Ingresos obtenidos por las ventas
    SUM(
        TRY_CAST(ti.quantity AS DECIMAL(18,2))
        *
        TRY_CAST(ti.unit_price AS DECIMAL(18,2))
    ) AS ventas,

    -- Costo de los productos vendidos
    SUM(
        TRY_CAST(ti.quantity AS DECIMAL(18,2))
        *
        TRY_CAST(p.cost AS DECIMAL(18,2))
    ) AS costo,

    -- Utilidad generada
    SUM(
        TRY_CAST(ti.quantity AS DECIMAL(18,2))
        *
        TRY_CAST(ti.unit_price AS DECIMAL(18,2))
    )
    -
    SUM(
        TRY_CAST(ti.quantity AS DECIMAL(18,2))
        *
        TRY_CAST(p.cost AS DECIMAL(18,2))
    ) AS ganancia

FROM transaction_items ti

INNER JOIN products p
    ON p.item_id = ti.item_id

INNER JOIN vendors v
    ON p.vendor_id = v.vendor_id

GROUP BY
    v.vendor_name,
    p.category

-- Mostrar primero los proveedores más rentables
ORDER BY ganancia DESC;


/*
Objetivo:
Encontrar productos que presentan pocas ventas.
Esto puede indicar baja demanda o posibles problemas
de abastecimiento.
*/

SELECT
    p.item_id,
    p.item_name,
    p.category,

    -- Cantidad total de unidades vendidas
    SUM(
        TRY_CAST(ti.quantity AS DECIMAL(18,2))
    ) AS unidades_vendidas

FROM products p

INNER JOIN transaction_items ti
    ON p.item_id = ti.item_id

GROUP BY
    p.item_id,
    p.item_name,
    p.category

-- Mostrar primero los productos menos vendidos
ORDER BY unidades_vendidas ASC;


/*
Objetivo:
Comparar el comportamiento de compra
entre productos vendidos con promoción
y productos vendidos sin promoción.
*/

SELECT

    -- Clasificación según la promoción
    CASE
        WHEN was_on_promo = 'TRUE'
        THEN 'Con Promoción'
        ELSE 'Sin Promoción'
    END AS grupo,

    -- Cantidad de registros analizados
    COUNT(*) AS total_items,

    -- Precio promedio de venta
    AVG(
        TRY_CAST(unit_price AS DECIMAL(18,2))
    ) AS precio_promedio,

    -- Cantidad de unidades vendidas
    SUM(
        TRY_CAST(quantity AS DECIMAL(18,2))
    ) AS unidades_vendidas

FROM transaction_items

GROUP BY
    CASE
        WHEN was_on_promo = 'TRUE'
        THEN 'Con Promoción'
        ELSE 'Sin Promoción'
    END;