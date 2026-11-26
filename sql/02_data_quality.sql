
-- ShopPulse: Data Quality Checks

-- 1. Check total records in each table
SELECT 'orders' AS table_name, COUNT(*) AS total_records
FROM analytics.orders
UNION ALL
SELECT 'order_items', COUNT(*)
FROM analytics.order_items
UNION ALL
SELECT 'customers', COUNT(*)
FROM analytics.customers;


-- 2. Check duplicate order IDs
SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM analytics.orders
GROUP BY order_id
HAVING COUNT(*) > 1;


-- 3. Check missing values in orders
SELECT
    COUNT(*) FILTER (WHERE order_id IS NULL) AS missing_order_id,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS missing_customer_id,
    COUNT(*) FILTER (WHERE order_status IS NULL) AS missing_order_status
FROM analytics.orders;


-- 4. Check missing values in order_items
SELECT
    COUNT(*) FILTER (WHERE order_id IS NULL) AS missing_order_id,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS missing_product_id,
    COUNT(*) FILTER (WHERE price IS NULL) AS missing_price,
    COUNT(*) FILTER (WHERE freight_value IS NULL) AS missing_freight
FROM analytics.order_items;


-- 5. Check invalid prices
SELECT *
FROM analytics.order_items
WHERE price < 0 OR freight_value < 0;


-- 6. Check duplicate customer IDs
SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM analytics.customers
GROUP BY customer_id
HAVING COUNT(*) > 1;
