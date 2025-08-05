-- 🟦 Monthly KPIs View
CREATE VIEW vw_monthly_kpis AS
SELECT
  DATE(SalesOrderDate, 'start of month') AS month,
  SUM(QuantityOrdered * UnitSalePrice) AS total_revenue,
  COUNT(DISTINCT InvoiceNumber) AS total_orders,
  COUNT(DISTINCT CustomerID) AS unique_customers
FROM sales_data
GROUP BY month;

-- 🟩 Monthly Growth View
CREATE VIEW vw_monthly_growth AS
WITH monthly_sales AS (
  SELECT
    DATE(SalesOrderDate, 'start of month') AS month,
    SUM(QuantityOrdered * UnitSalePrice) AS revenue
  FROM sales_data
  GROUP BY month
)
SELECT
  month,
  revenue,
  LAG(revenue) OVER (ORDER BY month) AS prev_month,
  ROUND(
    (revenue - LAG(revenue) OVER (ORDER BY month)) * 100.0 /
    NULLIF(LAG(revenue) OVER (ORDER BY month), 0), 2
  ) AS percent_growth
FROM monthly_sales;

-- 🟨 Customer Cohort View
CREATE VIEW vw_customer_cohorts AS
WITH first_purchase AS (
  SELECT CustomerID, MIN(DATE(SalesOrderDate, 'start of month')) AS cohort_month
  FROM sales_data
  GROUP BY CustomerID
),
orders AS (
  SELECT
    s.CustomerID,
    DATE(s.SalesOrderDate, 'start of month') AS order_month,
    f.cohort_month
  FROM sales_data s
  JOIN first_purchase f ON s.CustomerID = f.CustomerID
),
cohort_data AS (
  SELECT
    cohort_month,
    STRFTIME('%m', order_month) - STRFTIME('%m', cohort_month) AS months_since_first,
    COUNT(DISTINCT CustomerID) AS retained_customers
  FROM orders
  GROUP BY cohort_month, months_since_first
)
SELECT * FROM cohort_data;
