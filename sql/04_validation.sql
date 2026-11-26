
-- ShopPulse: Data Validation

-- 1. Validate total records
SELECT
    (SELECT COUNT(*) FROM analytics.orders) AS total_orders,
    (SELECT COUNT(*) FROM analytics.order_items) AS total_order_items,
    (SELECT COUNT(*) FROM analytics.customers) AS total_customer_records;


-- 2. Validate delivered orders
SELECT
    COUNT(*) AS delivered_orders
FROM analytics.orders
WHERE order_status = 'delivered';


-- 3. Validate total product revenue
SELECT
    ROUND(SUM(oi.price)::numeric, 2) AS total_product_revenue
FROM analytics.orders o
JOIN analytics.order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';


-- 4. Validate average delivery time
SELECT
    ROUND(
        AVG(
            EXTRACT(EPOCH FROM
                (order_delivered_customer_date - order_purchase_timestamp)
            ) / 86400
        )::numeric, 2
    ) AS average_delivery_days
FROM analytics.orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;


-- 5. Validate late delivery count
SELECT
    COUNT(*) AS late_deliveries
FROM analytics.orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
  AND order_delivered_customer_date > order_estimated_delivery_date;


-- 6. Validate unique customers
SELECT
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM analytics.customers;

