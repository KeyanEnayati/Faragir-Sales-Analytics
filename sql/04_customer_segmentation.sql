-- RFM Segmentation
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
