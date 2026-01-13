# SQL Analytics Projects

This repository showcases real-world SQL analytics projects focused on extracting actionable business insights from relational data.  
The analyses are designed to reflect common business problems and interview-style analytics tasks.

---

## 🔧 Tools & Skills
- PostgreSQL
- Advanced SQL (CTEs, Window Functions, Joins)
- Data Analysis & Business Insight Generation

---

## 📊 Project: Customer Revenue & Retention Analysis

### Objective
Analyze customer purchasing behavior, revenue trends, and retention patterns to support data-driven business decisions.

---

### Key SQL Concepts Used
- Multi-table joins
- Aggregations & GROUP BY
- Common Table Expressions (CTEs)
- Window functions (ROW_NUMBER, RANK, LAG)

---

### Business Questions Answered
- How does revenue change month over month?
- Who are the top revenue-generating customers?
- How many customers are active each month (retention proxy)?
- How does revenue performance vary by customer signup cohort?

---

## 📈 Business Value
Insights from this analysis help stakeholders:
- Identify and prioritize high-value customers
- Monitor revenue growth and seasonality
- Evaluate customer retention trends
- Compare long-term performance of different customer cohorts

---

## ▶️ How to Run This Project

1. Use **PostgreSQL** or any SQL editor that supports window functions.
2. Run `schema_and_sample_data.sql` to create tables and load sample data.
3. Run `customer_revenue_retention.sql` to execute the analysis queries.
4. Review query outputs to interpret revenue, retention, and cohort insights.

> Note: Sample data is intentionally small and simplified to focus on SQL logic and analytical thinking.

---

## 🗣️ Interview Talking Points (2–3 Minutes)

**Problem**  
The business wants to understand overall revenue performance and customer retention behavior.

**Approach**
1. Calculated monthly revenue and active customers to assess overall trends.
2. Identified top customers by revenue and order frequency to highlight high-value segments.
3. Used monthly active customers as a simple retention proxy.
4. Built a cohort analysis to compare revenue performance by signup month.
5. Calculated month-over-month revenue growth using window functions.

**Insights I Would Look For**
- Revenue seasonality or declining trends
- Revenue concentration among a small group of customers
- Retention stability or drop-off over time
- Strong vs weak customer cohorts

**Next Steps (If This Were a Real Company)**
- Segment results by country, product, or channel
- Identify churn-risk customers based on inactivity
- Build a Power BI dashboard to monitor KPIs over time

---

## 📌 Author
**Mahmoud Zamani**  
Data Analyst | SQL | Power BI | Python  
Toronto, Canada
