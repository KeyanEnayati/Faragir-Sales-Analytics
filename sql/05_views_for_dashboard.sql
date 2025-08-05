-- Monthly KPI View
CREATE VIEW vw_monthly_kpis AS
SELECT
  DATE_TRUNC('month', SalesOrderDate) AS month,
  SUM(QuantityOrdered * UnitSalePrice) AS total_revenue,
  COUNT(DISTINCT InvoiceNumber) AS total_orders,
  COUNT(DISTINCT CustomerID) AS unique_customers
FROM sales_data
GROUP BY month;

-- RFM View
CREATE VIEW vw_customer_segments AS
WITH rfm AS (
  SELECT
    CustomerID,
    MAX(SalesOrderDate) AS last_order,
    COUNT(*) AS frequency,
    SUM(QuantityOrdered * UnitSalePrice) AS monetary
  FROM sales_data
  GROUP BY CustomerID
)
SELECT *,
  CURRENT_DATE - last_order AS recency_days
FROM rfm;
