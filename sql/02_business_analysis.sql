-- =====================================================
-- PROJECT: Olist E-commerce Business Analysis
-- DATABASE: ecommerce_analysis
-- TOOL: MySQL 8.0.46
-- =====================================================

USE ecommerce_analysis;


-- =====================================================
-- ANALYSIS 01: Order Status Distribution
-- =====================================================
-- Business Question:
-- What is the distribution of orders by status?

SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM olist_orders_dataset),
        2
    ) AS percentage
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY total_orders DESC;

-- =====================================================
-- ANALYSIS 02: Payment Method Analysis
-- =====================================================
-- Business Question:
-- Which payment methods are most commonly used by customers?

SELECT
    payment_type,
    COUNT(*) AS total_transactions,
    ROUND(SUM(payment_value), 2) AS total_payment,
    ROUND(
        SUM(payment_value) * 100.0 /
        (SELECT SUM(payment_value)
         FROM olist_order_payments_dataset),
        2
    ) AS revenue_percentage
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY total_payment DESC;

-- =====================================================
-- ANALYSIS 03: Top Product Categories by Revenue
-- =====================================================
-- Business Question:
-- Which product categories generate the highest revenue?

SELECT
    p.product_category_name,
    COUNT(*) AS total_items_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;

-- =====================================================
-- ANALYSIS 04: Top Customers by Spending
-- =====================================================
-- Business Question:
-- Who are the top 10 customers based on total spending?

SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_spending
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
JOIN olist_order_payments_dataset p
    ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spending DESC
LIMIT 10;

-- =====================================================
-- ANALYSIS 05: Average Order Value (AOV)
-- =====================================================
-- Business Question:
-- What is the average amount spent per order?

SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(payment_value), 2) AS total_revenue,
    ROUND(
        SUM(payment_value) / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM olist_order_payments_dataset;

-- =====================================================
-- ANALYSIS 06: Monthly Revenue Analysis
-- =====================================================
-- Business Question:
-- How does revenue change month by month?

SELECT
    DATE_FORMAT(
        STR_TO_DATE(o.order_purchase_timestamp, '%d-%m-%Y %H:%i'),
        '%Y-%m'
    ) AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS monthly_revenue
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p
    ON o.order_id = p.order_id
GROUP BY order_month
ORDER BY order_month;

-- =====================================================
-- ANALYSIS 07: State-wise Sales Analysis
-- =====================================================
-- Business Question:
-- Which Brazilian states generate the highest revenue?

SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_revenue
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
JOIN olist_order_payments_dataset p
    ON o.order_id = p.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;

-- =====================================================
-- ANALYSIS 08: Repeat Customer Analysis
-- =====================================================
-- Business Question:
-- What percentage of customers placed more than one order?

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)

SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END)
        AS repeat_customers,
    ROUND(
        SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS repeat_customer_percentage
FROM customer_orders;

-- =====================================================
-- ANALYSIS 09: Late Delivery Analysis
-- =====================================================
-- Business Question:
-- How many orders were delivered later than the estimated delivery date?

SELECT
    COUNT(*) AS total_delivered_orders,
    SUM(
        CASE
            WHEN DATE(
                STR_TO_DATE(order_delivered_customer_date, '%d-%m-%Y %H:%i')
            ) >
            DATE(
                STR_TO_DATE(order_estimated_delivery_date, '%d-%m-%Y %H:%i')
            )
            THEN 1
            ELSE 0
        END
    ) AS late_delivered_orders,
    ROUND(
        SUM(
            CASE
                WHEN DATE(
                    STR_TO_DATE(order_delivered_customer_date, '%d-%m-%Y %H:%i')
                ) >
                DATE(
                    STR_TO_DATE(order_estimated_delivery_date, '%d-%m-%Y %H:%i')
                )
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS late_delivery_percentage
FROM olist_orders_dataset
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;

-- =====================================================
-- ANALYSIS 10: Order Cancellation Analysis
-- =====================================================
-- Business Question:
-- What percentage of orders were cancelled?

SELECT
    COUNT(*) AS total_orders,
    SUM(
        CASE
            WHEN order_status = 'canceled' THEN 1
            ELSE 0
        END
    ) AS cancelled_orders,
    ROUND(
        SUM(
            CASE
                WHEN order_status = 'canceled' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS cancellation_percentage
FROM olist_orders_dataset;

-- =====================================================
-- ANALYSIS 11: Top Selling Products
-- =====================================================
-- Business Question:
-- Which individual products have the highest sales volume?

SELECT
    oi.product_id,
    p.product_category_name,
    COUNT(*) AS total_items_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p
    ON oi.product_id = p.product_id
GROUP BY
    oi.product_id,
    p.product_category_name
ORDER BY total_items_sold DESC
LIMIT 10;

-- =====================================================
-- ANALYSIS 12: Seller Performance Analysis
-- =====================================================
-- Business Question:
-- Which sellers generate the highest revenue?

SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,
    COUNT(*) AS total_items_sold,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM olist_order_items_dataset oi
JOIN olist_sellers_dataset s
    ON oi.seller_id = s.seller_id
GROUP BY
    s.seller_id,
    s.seller_city,
    s.seller_state
ORDER BY total_revenue DESC
LIMIT 10;

-- =====================================================
-- ANALYSIS 13: Freight Cost Analysis by Customer State
-- =====================================================
-- Business Question:
-- Which states have the highest average freight cost per order?

WITH order_freight AS (
    SELECT
        order_id,
        SUM(freight_value) AS total_freight
    FROM olist_order_items_dataset
    GROUP BY order_id
)

SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(f.total_freight), 2) AS total_freight,
    ROUND(AVG(f.total_freight), 2) AS avg_freight_per_order
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
JOIN order_freight f
    ON o.order_id = f.order_id
GROUP BY c.customer_state
ORDER BY avg_freight_per_order DESC;

-- =====================================================
-- ANALYSIS 14: Month-over-Month Revenue Growth
-- =====================================================
-- Business Question:
-- How does monthly revenue change compared with the previous month?

WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(
            STR_TO_DATE(o.order_purchase_timestamp, '%d-%m-%Y %H:%i'),
            '%Y-%m'
        ) AS order_month,
        ROUND(SUM(p.payment_value), 2) AS total_revenue
    FROM olist_orders_dataset o
    JOIN olist_order_payments_dataset p
        ON o.order_id = p.order_id
    GROUP BY order_month
),

revenue_comparison AS (
    SELECT
        order_month,
        total_revenue,
        LAG(total_revenue) OVER (
            ORDER BY order_month
        ) AS previous_month_revenue
    FROM monthly_revenue
)

SELECT
    order_month,
    total_revenue,
    previous_month_revenue,
    ROUND(
        total_revenue - previous_month_revenue, 2
    ) AS revenue_difference,
    ROUND(
        (
            (total_revenue - previous_month_revenue)
            / NULLIF(previous_month_revenue, 0)
        ) * 100, 2
    ) AS growth_percentage
FROM revenue_comparison
ORDER BY order_month;

-- =====================================================
-- ANALYSIS 15: Product Category Ranking
-- =====================================================
-- Business Question:
-- How do product categories rank based on total revenue?

WITH category_sales AS (
    SELECT
        COALESCE(p.product_category_name, 'unknown') AS product_category,
        COUNT(*) AS total_items_sold,
        ROUND(SUM(oi.price), 2) AS total_revenue
    FROM olist_order_items_dataset oi
    JOIN olist_products_dataset p
        ON oi.product_id = p.product_id
    GROUP BY COALESCE(p.product_category_name, 'unknown')
),

category_ranking AS (
    SELECT
        product_category,
        total_items_sold,
        total_revenue,
        RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank
    FROM category_sales
)

SELECT
    revenue_rank,
    product_category,
    total_items_sold,
    total_revenue
FROM category_ranking
ORDER BY revenue_rank;