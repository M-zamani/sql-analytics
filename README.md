# sql-analytics
# SQL Analytics Projects

This repository contains real-world SQL analytics projects focused on extracting business insights from relational data.

## 🔧 Tools & Skills
- PostgreSQL
- Advanced SQL (CTEs, Window Functions, Joins)
- Data Analysis & Business Insights

## 📊 Project: Customer Revenue & Retention Analysis

**Objective:**  
Analyze customer purchasing behavior, revenue contribution, and retention patterns to support business decision-making.

**Key SQL Concepts Used:**
- Multi-table joins
- Aggregations & GROUP BY
- CTEs
- Window functions (ROW_NUMBER, RANK)

**Business Questions Answered:**
- Who are the top revenue-generating customers?
- How does customer retention change over time?
- Which customer segments drive the most revenue?

## 📈 Business Value
Insights from this analysis help stakeholders:
- Identify high-value customers
- Improve retention strategies
- Monitor revenue performance

## 📌 Author
Mahmoud Zamani  
Data Analyst | SQL | Power BI | Python  
Toronto, Canada
## 🗣️ Interview Talking Points (2–3 minutes)

**Problem:** The business wants to understand revenue performance and customer retention behavior.

**Approach:**
1. Calculated monthly revenue and active customers to see overall performance trends.
2. Identified top customers by revenue and order count to highlight high-value segments.
3. Measured monthly active customers as a retention proxy (customers with at least one order per month).
4. Built cohort revenue analysis to compare how different signup cohorts perform over time.
5. Added MoM growth to quantify changes and support performance reporting.

**Key Insights I would look for:**
- Seasonality or declines in monthly revenue
- Dependence on a small group of high-value customers
- Retention trends: stable vs decreasing monthly active customers
- Strong vs weak cohorts (which cohorts sustain revenue longer)

**Next Steps (if this were a real company):**
- Segment by country/product/channel (if available) to find drivers
- Identify churn-risk customers (no orders in last X days)
- Build a Power BI dashboard to track KPIs monthly

