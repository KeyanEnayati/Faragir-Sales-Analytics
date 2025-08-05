-- Year-over-Year Revenue
SELECT
  EXTRACT(YEAR FROM SalesOrderDate) AS year,
  EXTRACT(MONTH FROM SalesOrderDate) AS month,
  SUM(QuantityOrdered * UnitSalePrice) AS total_revenue
FROM sales_data
GROUP BY year, month
ORDER BY year, month;

-- Customer Cohort Retention
WITH first_purchase AS (
  SELECT CustomerID, MIN(SalesOrderDate) AS first_order_month
  FROM sales_data
  GROUP BY CustomerID
),
orders_with_cohort AS (
  SELECT
    s.CustomerID,
    DATE_TRUNC('month', s.SalesOrderDate) AS order_month,
    DATE_TRUNC('month', f.first_order_month) AS cohort_month
  FROM sales_data s
  JOIN first_purchase f ON s.CustomerID = f.CustomerID
),
cohort_analysis AS (
  SELECT
    cohort_month,
    DATE_PART('month', AGE(order_month, cohort_month)) AS months_since_first,
    COUNT(DISTINCT CustomerID) AS retained_customers
  FROM orders_with_cohort
  GROUP BY cohort_month, months_since_first
)
SELECT *
FROM cohort_analysis
ORDER BY cohort_month, months_since_first;

-- Monthly Growth
WITH monthly_sales AS (
  SELECT
    DATE_TRUNC('month', SalesOrderDate) AS month,
    SUM(QuantityOrdered * UnitSalePrice) AS revenue
  FROM sales_data
  GROUP BY month
)
SELECT
  month,
  revenue,
  LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,
  ROUND(
    (revenue - LAG(revenue) OVER (ORDER BY month)) * 100.0 /
    NULLIF(LAG(revenue) OVER (ORDER BY month), 0), 2
  ) AS percent_growth
FROM monthly_sales;
