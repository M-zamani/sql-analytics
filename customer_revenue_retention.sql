-- customer_revenue_retention.sql
-- Customer Revenue & Retention Analysis (PostgreSQL)
-- Outputs are produced as final SELECT statements at the bottom.

-- ============================================================
-- 00) Data Quality Checks (quick recruiter-friendly checks)
-- ============================================================

-- 00.1 Duplicate emails (should be 0 rows)
SELECT email, COUNT(*) AS cnt
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;

-- 00.2 Null checks (should be 0 rows)
SELECT *
FROM customers
WHERE full_name IS NULL OR email IS NULL OR segment IS NULL OR country IS NULL OR created_at IS NULL;

-- 00.3 Completed-order revenue by order_id (helps reconcile totals)
WITH completed_line_revenue AS (
  SELECT
    o.order_id,
    SUM(oi.quantity * oi.unit_price) AS line_revenue
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  WHERE o.order_status = 'completed'
  GROUP BY o.order_id
)
SELECT *
FROM completed_line_revenue
ORDER BY line_revenue DESC;

-- ============================================================
-- 01) Base fact table (completed orders joined to items)
-- ============================================================
WITH base_completed AS (
  SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    DATE_TRUNC('month', o.order_date)::date AS order_month,
    o.channel,
    oi.product_id,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price)::numeric(12,2) AS line_revenue
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  WHERE o.order_status = 'completed'
),

-- ============================================================
-- 02) Customer revenue metrics
-- ============================================================
customer_revenue AS (
  SELECT
    c.customer_id,
    c.full_name,
    c.segment,
    c.country,
    MIN(b.order_date) AS first_order_date,
    MAX(b.order_date) AS last_order_date,
    COUNT(DISTINCT b.order_id) AS completed_orders,
    SUM(b.line_revenue)::numeric(12,2) AS total_revenue
  FROM customers c
  LEFT JOIN base_completed b ON b.customer_id = c.customer_id
  GROUP BY 1,2,3,4
),

-- ============================================================
-- 03) Revenue by segment
-- ============================================================
segment_revenue AS (
  SELECT
    segment,
    COUNT(*) FILTER (WHERE total_revenue IS NOT NULL) AS customers_with_revenue,
    SUM(COALESCE(total_revenue,0))::numeric(12,2) AS segment_total_revenue,
    AVG(NULLIF(total_revenue,0))::numeric(12,2) AS avg_revenue_per_customer
  FROM customer_revenue
  GROUP BY 1
),

-- ============================================================
-- 04) Monthly active customers
-- ============================================================
monthly_active AS (
  SELECT
    order_month,
    COUNT(DISTINCT customer_id) AS active_customers
  FROM base_completed
  GROUP BY 1
),

-- ============================================================
-- 05) Monthly retention (active in M and also active in M-1)
-- ============================================================
customer_months AS (
  SELECT DISTINCT
    customer_id,
    order_month
  FROM base_completed
),
retention_pairs AS (
  SELECT
    cm.order_month AS month,
    COUNT(DISTINCT cm.customer_id) AS retained_customers
  FROM customer_months cm
  JOIN customer_months prev
    ON prev.customer_id = cm.customer_id
   AND prev.order_month = (cm.order_month - INTERVAL '1 month')::date
  GROUP BY 1
),
monthly_retention AS (
  SELECT
    ma.order_month AS month,
    ma.active_customers,
    COALESCE(rp.retained_customers,0) AS retained_customers,
    CASE
      WHEN LAG(ma.active_customers) OVER (ORDER BY ma.order_month) IS NULL THEN NULL
      ELSE ROUND(
        (COALESCE(rp.retained_customers,0)::numeric
         / NULLIF(LAG(ma.active_customers) OVER (ORDER BY ma.order_month),0)::numeric) * 100, 2
      )
    END AS retention_rate_pct
  FROM monthly_active ma
  LEFT JOIN retention_pairs rp ON rp.month = ma.order_month
),

-- ============================================================
-- 06) Cohort retention (cohort month = first purchase month)
-- ============================================================
first_month AS (
  SELECT
    customer_id,
    MIN(order_month) AS cohort_month
  FROM customer_months
  GROUP BY 1
),
cohort_activity AS (
  SELECT
    fm.cohort_month,
    cm.order_month,
    (DATE_PART('year', cm.order_month) * 12 + DATE_PART('month', cm.order_month))
    - (DATE_PART('year', fm.cohort_month) * 12 + DATE_PART('month', fm.cohort_month)) AS month_index,
    COUNT(DISTINCT cm.customer_id) AS active_customers
  FROM first_month fm
  JOIN customer_months cm ON cm.customer_id = fm.customer_id
  GROUP BY 1,2,3
),
cohort_sizes AS (
  SELECT cohort_month, COUNT(*) AS cohort_size
  FROM first_month
  GROUP BY 1
),
cohort_retention AS (
  SELECT
    ca.cohort_month,
    ca.month_index,
    ca.active_customers,
    cs.cohort_size,
    ROUND((ca.active_customers::numeric / NULLIF(cs.cohort_size,0)) * 100, 2) AS cohort_retention_pct
  FROM cohort_activity ca
  JOIN cohort_sizes cs ON cs.cohort_month = ca.cohort_month
)

-- ============================================================
-- FINAL OUTPUTS
-- ============================================================

-- A) Top customers by revenue
SELECT
  customer_id,
  full_name,
  segment,
  country,
  completed_orders,
  total_revenue
FROM customer_revenue
WHERE total_revenue IS NOT NULL
ORDER BY total_revenue DESC
LIMIT 20;

-- B) Revenue by segment
SELECT *
FROM segment_revenue
ORDER BY segment_total_revenue DESC;

-- C) Monthly retention rate
SELECT *
FROM monthly_retention
ORDER BY month;

-- D) Cohort retention table (cohort_month x month_index)
SELECT
  cohort_month,
  month_index,
  active_customers,
  cohort_size,
  cohort_retention_pct
FROM cohort_retention
ORDER BY cohort_month, month_index;
