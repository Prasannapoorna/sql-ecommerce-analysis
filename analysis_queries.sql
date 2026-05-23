-- ============================================================
-- E-COMMERCE DATA ANALYSIS - SQL QUERIES
-- Author: Kuntumuri Sai Prasanna
-- Tools: SQL (MySQL / Oracle compatible)
-- Dataset: 50 orders across 5 months (Jan-May 2024)
-- ============================================================

-- ============================================================
-- 1. BASIC OVERVIEW
-- ============================================================

-- Total number of orders
SELECT COUNT(order_id) AS total_orders FROM orders;

-- Total revenue generated
SELECT ROUND(SUM(quantity * unit_price), 2) AS total_revenue FROM orders;

-- Orders by status
SELECT status, COUNT(*) AS order_count
FROM orders
GROUP BY status
ORDER BY order_count DESC;


-- ============================================================
-- 2. REVENUE ANALYSIS
-- ============================================================

-- Revenue by product category
SELECT 
    category,
    COUNT(order_id) AS total_orders,
    SUM(quantity) AS units_sold,
    ROUND(SUM(quantity * unit_price), 2) AS total_revenue
FROM orders
WHERE status = 'Delivered'
GROUP BY category
ORDER BY total_revenue DESC;


-- Revenue by region
SELECT 
    region,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(quantity * unit_price), 2) AS total_revenue,
    ROUND(AVG(quantity * unit_price), 2) AS avg_order_value
FROM orders
WHERE status = 'Delivered'
GROUP BY region
ORDER BY total_revenue DESC;


-- Monthly revenue trend
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(quantity * unit_price), 2) AS monthly_revenue
FROM orders
WHERE status = 'Delivered'
GROUP BY month
ORDER BY month;


-- ============================================================
-- 3. CUSTOMER ANALYSIS
-- ============================================================

-- Top 10 customers by revenue
SELECT 
    customer_id,
    customer_name,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(quantity * unit_price), 2) AS total_spent
FROM orders
WHERE status = 'Delivered'
GROUP BY customer_id, customer_name
ORDER BY total_spent DESC
LIMIT 10;


-- Repeat customers (purchased more than once)
SELECT 
    customer_id,
    customer_name,
    COUNT(order_id) AS purchase_count
FROM orders
GROUP BY customer_id, customer_name
HAVING COUNT(order_id) > 1
ORDER BY purchase_count DESC;


-- Customer segmentation using CASE
SELECT 
    customer_id,
    customer_name,
    ROUND(SUM(quantity * unit_price), 2) AS total_spent,
    CASE 
        WHEN SUM(quantity * unit_price) >= 50000 THEN 'Premium'
        WHEN SUM(quantity * unit_price) >= 20000 THEN 'Regular'
        ELSE 'Occasional'
    END AS customer_segment
FROM orders
WHERE status = 'Delivered'
GROUP BY customer_id, customer_name
ORDER BY total_spent DESC;


-- ============================================================
-- 4. PRODUCT ANALYSIS
-- ============================================================

-- Best selling products by revenue
SELECT 
    product,
    category,
    SUM(quantity) AS units_sold,
    ROUND(SUM(quantity * unit_price), 2) AS total_revenue
FROM orders
WHERE status = 'Delivered'
GROUP BY product, category
ORDER BY total_revenue DESC
LIMIT 10;


-- Return rate by category
SELECT 
    category,
    COUNT(CASE WHEN status = 'Returned' THEN 1 END) AS returns,
    COUNT(order_id) AS total_orders,
    ROUND(COUNT(CASE WHEN status = 'Returned' THEN 1 END) * 100.0 / COUNT(order_id), 2) AS return_rate_pct
FROM orders
GROUP BY category
ORDER BY return_rate_pct DESC;


-- ============================================================
-- 5. ADVANCED SQL - WINDOW FUNCTIONS
-- ============================================================

-- Running total revenue by month
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    ROUND(SUM(quantity * unit_price), 2) AS monthly_revenue,
    ROUND(SUM(SUM(quantity * unit_price)) OVER (ORDER BY DATE_FORMAT(order_date, '%Y-%m')), 2) AS cumulative_revenue
FROM orders
WHERE status = 'Delivered'
GROUP BY month
ORDER BY month;


-- Rank customers by spending within each region
SELECT 
    region,
    customer_name,
    ROUND(SUM(quantity * unit_price), 2) AS total_spent,
    RANK() OVER (PARTITION BY region ORDER BY SUM(quantity * unit_price) DESC) AS rank_in_region
FROM orders
WHERE status = 'Delivered'
GROUP BY region, customer_id, customer_name
ORDER BY region, rank_in_region;


-- Month-over-month revenue growth
WITH monthly_revenue AS (
    SELECT 
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        ROUND(SUM(quantity * unit_price), 2) AS revenue
    FROM orders
    WHERE status = 'Delivered'
    GROUP BY month
)
SELECT 
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) * 100.0 / 
           LAG(revenue) OVER (ORDER BY month), 2) AS growth_pct
FROM monthly_revenue
ORDER BY month;
