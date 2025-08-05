-- ================================
-- SALES KPIs ANALYSIS
-- ================================

-- 🔹 Overall KPIs
SELECT
  COUNT(DISTINCT InvoiceNumber) AS total_orders,
  COUNT(DISTINCT CustomerID) AS unique_customers,
  ROUND(SUM(QuantityOrdered * UnitSalePrice), 2) AS total_revenue,
  ROUND(AVG(QuantityOrdered * UnitSalePrice), 2) AS avg_order_value
FROM sales_data;

-- 🔹 Revenue by Sales Channel
SELECT
  SalesChannel,
  COUNT(DISTINCT InvoiceNumber) AS total_orders,
  SUM(QuantityOrdered * UnitSalePrice) AS revenue
FROM sales_data
GROUP BY SalesChannel;

-- 🔹 Top 10 customers by revenue:
SELECT
  CustomerID,
  SUM(QuantityOrdered * UnitSalePrice) AS customer_revenue
FROM sales_data
GROUP BY CustomerID
ORDER BY customer_revenue DESC
LIMIT 10;

-- 🔹 Monthly Revenue Trend
SELECT
  SUBSTR(SalesOrderDate, 1, 7) AS month,
  ROUND(SUM(QuantityOrdered * UnitSalePrice), 2) AS monthly_revenue
FROM sales_data
GROUP BY month
ORDER BY month;
