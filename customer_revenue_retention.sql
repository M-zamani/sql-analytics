/*
Customer Revenue & Retention Analysis
Author: Mahmoud Zamani
Goal:
- Understand revenue trends over time
- Identify high-value customers
- Measure monthly active customers (a proxy for retention)
- Analyze revenue performance by signup cohort

Assumptions:
- "Active customer" = customer placed >= 1 order in a given month.
- Monetary values are stored in orders.order_amount.
*/

-- =========================
-- 1) Monthly Revenue Trend
-- =========================
-- Why it matters:
-- Revenue trend helps stakeholders detect growth/decline, seasonality, and performance shifts.
-- Output:
-- One row per month with total revenue.
SELECT
    DATE_TRUNC('month', o.order_date) AS revenue_month,
    SUM(o.order_amount)               AS total_revenue,
    COUNT(*)                          AS total_orders,
    COUNT(DISTINCT o.customer_id)     AS active_customers
FROM orders o
GROUP BY 1
ORDER BY 1;


-- =====================================
-- 2) Top 10 Customers by Total Revenue
-- =====================================
-- Why it matters:
-- Identifying top customers supports VIP programs, retention spend allocation, and account management.
-- Notes:
-- Join to customers to allow future segmentation (country, signup cohort, etc.).
SELECT
    c.customer_id,
    c.country,
    c.signup_date,
    SUM(o.order_amount) AS total_revenue,
    COUNT(*)            AS total_orders,
    MAX(o.order_date)   AS last_order_date
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY 1,2,3
ORDER BY total_revenue DESC
LIMIT 10;


-- ==========================================
-- 3) Monthly Active Customers (Retention Proxy)
-- ==========================================
-- Why it matters:
-- Monthly active customers is a simple retention proxy:
-- it shows how many unique customers return and transact each month.
-- Method:
-- Deduplicate to 1 row per customer per month, then count customers per month.
WITH customer_month_activity AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', order_date) AS order_month
    FROM orders
    GROUP BY 1,2
)
SELECT
    order_month,
    COUNT(DISTINCT customer_id) AS active_customers
FROM customer_month_activity
GROUP BY 1
ORDER BY 1;


-- ==========================================
-- 4) Cohort Revenue (Signup Cohort vs Revenue Month)
-- ==========================================
-- Why it matters:
-- Cohorts answer: "Do customers who signed up in a given month generate sustained revenue over time?"
-- Output:
-- cohort_month = month of signup
-- revenue_month = month of purchase
-- revenue = total revenue from that cohort in that revenue_month
WITH cohorts AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', signup_date) AS cohort_month
    FROM customers
),
cohort_revenue AS (
    SELECT
        c.cohort_month,
        DATE_TRUNC('month', o.order_date) AS revenue_month,
        SUM(o.order_amount)               AS revenue,
        COUNT(DISTINCT o.customer_id)     AS active_customers
    FROM cohorts c
    JOIN orders o
      ON c.customer_id = o.customer_id
    GROUP BY 1,2
)
SELECT
    cohort_month,
    revenue_month,
    revenue,
    active_customers
FROM cohort_revenue
ORDER BY cohort_month, revenue_month;


-- ==========================================
-- 5) (Bonus) MoM Revenue Growth %
-- ==========================================
-- Why it matters:
-- MoM growth is a common KPI in business reviews. Interviewers love this.
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', order_date) AS revenue_month,
        SUM(order_amount)               AS revenue
    FROM orders
    GROUP BY 1
)
SELECT
    revenue_month,
    revenue,
    LAG(revenue) OVER (ORDER BY revenue_month) AS prev_month_revenue,
    CASE
        WHEN LAG(revenue) OVER (ORDER BY revenue_month) IS NULL THEN NULL
        WHEN LAG(revenue) OVER (ORDER BY revenue_month) = 0 THEN NULL
        ELSE ROUND(
            (revenue - LAG(revenue) OVER (ORDER BY revenue_month))
            / LAG(revenue) OVER (ORDER BY revenue_month) * 100.0
        , 2)
    END AS mom_growth_pct
FROM monthly
ORDER BY revenue_month;
