-- Step 1: RFM base table
CREATE VIEW vw_customer_rfm AS
SELECT
  CustomerID,
  ROUND(JULIANDAY('now') - JULIANDAY(MAX(SalesOrderDate))) AS recency,
  COUNT(*) AS frequency,
  ROUND(SUM(QuantityOrdered * UnitSalePrice), 2) AS monetary
FROM sales_data
GROUP BY CustomerID;

-- Step 2: Add segments (simple tiering example)
SELECT *,
  CASE
    WHEN recency <= 30 THEN 'New'
    WHEN recency <= 90 THEN 'Active'
    WHEN recency <= 180 THEN 'At Risk'
    ELSE 'Churned'
  END AS recency_segment,
  CASE
    WHEN frequency >= 10 THEN 'Loyal'
    WHEN frequency >= 5 THEN 'Returning'
    ELSE 'One-Time'
  END AS frequency_segment,
  CASE
    WHEN monetary >= 100000 THEN 'High-Value'
    WHEN monetary >= 50000 THEN 'Mid-Value'
    ELSE 'Low-Value'
  END AS monetary_segment
FROM vw_customer_rfm;
