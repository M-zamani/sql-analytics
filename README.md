# SQL Analytics Projects (PostgreSQL)

## Project: Customer Revenue & Retention Analysis

**Goal:** Identify top customers, revenue drivers, and retention trends to support growth decisions.  
**Tech:** PostgreSQL • CTEs • Window Functions • Joins • Cohort/Retention Logic

---

## What’s inside

- `schema.sql` — tables + constraints
- `sample_data.sql` — small, realistic dataset to run locally
- `customer_revenue_retention.sql` — analysis queries (step-by-step) + final outputs

---

## Data model (schema)

**customers**
- `customer_id` (PK)
- `full_name`
- `email` (unique)
- `segment` (SMB / Mid-Market / Enterprise)
- `country`
- `created_at`

**products**
- `product_id` (PK)
- `product_name`
- `category`
- `unit_price`

**orders**
- `order_id` (PK)
- `customer_id` (FK)
- `order_date`
- `order_status` (completed / returned / cancelled)
- `channel` (web / mobile / partner)

**order_items**
- `order_item_id` (PK)
- `order_id` (FK)
- `product_id` (FK)
- `quantity`
- `unit_price` (captured at purchase time)

---

## How to run (PostgreSQL)

1) Create a database (example):
```sql
CREATE DATABASE analytics_portfolio;
```

2) Connect to the DB and run:
```sql
\i schema.sql
\i sample_data.sql
\i customer_revenue_retention.sql
```

---

## Key outputs (what recruiters can scan)

- **Top customers by revenue** (Top 20)
- **Revenue by segment** (SMB / Mid-Market / Enterprise)
- **Monthly retention rate (%)**
- **Cohort retention** (cohort month → retained customers by month index)
- **Data quality checks** (nulls/duplicates, revenue reconciliation)

---

## Assumptions (explicit on purpose)

- **Revenue** includes only `order_status = 'completed'`
- **Monthly retention**: a customer is “retained” in month *M* if they also purchased in month *M-1*
- Timestamps are stored as UTC dates for simplicity

---

## Indexing (performance notes)

If this were large-scale, recommended indexes:
- `orders (customer_id, order_date)`
- `order_items (order_id)`
- `order_items (product_id)`
- `customers (segment)`

---

## Next upgrades (optional)

- Add an RFM segmentation project (Recency/Frequency/Monetary)
- Add cohort heatmap export (to CSV) for visualization in Power BI/Tableau
