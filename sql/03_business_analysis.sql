
-- ShopPulse: Business Analysis

-- 1. Total revenue from delivered orders
SELECT
    ROUND(SUM(oi.price)::numeric, 2) AS total_revenue
FROM analytics.orders o
JOIN analytics.order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';


-- 2. Total freight charges
SELECT
    ROUND(SUM(oi.freight_value)::numeric, 2) AS total_freight
FROM analytics.orders o
JOIN analytics.order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';


-- 3. Monthly revenue trend
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp)::date AS order_month,
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    ROUND(SUM(oi.price)::numeric, 2) AS total_revenue
FROM analytics.orders o
JOIN analytics.order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 1;


-- 4. Customer purchase frequency
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM analytics.customers c
JOIN analytics.orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id;


-- 5. Repeat customer analysis
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM analytics.customers c
    JOIN analytics.orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS unique_customers,
    COUNT(*) FILTER (WHERE total_orders = 1) AS one_time_customers,
    COUNT(*) FILTER (WHERE total_orders > 1) AS repeat_customers,
    ROUND(
        COUNT(*) FILTER (WHERE total_orders > 1) * 100.0
        / NULLIF(COUNT(*), 0), 2
    ) AS repeat_customer_rate
FROM customer_orders;


-- 6. Average delivery time and late deliveries
SELECT
    ROUND(
        AVG(
            EXTRACT(EPOCH FROM
                (order_delivered_customer_date - order_purchase_timestamp)
            ) / 86400
        )::numeric, 2
    ) AS avg_delivery_days,
    COUNT(*) FILTER (
        WHERE order_delivered_customer_date > order_estimated_delivery_date
    ) AS late_deliveries,
    ROUND(
        COUNT(*) FILTER (
            WHERE order_delivered_customer_date > order_estimated_delivery_date
        ) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS late_delivery_percentage
FROM analytics.orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;
