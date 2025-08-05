-- 🔍 advance analysis

-- 🔍 Identify the top products based on profit (revenue - production cost)
SELECT
  ProductCode,
  ROUND(SUM((UnitSalePrice - UnitProductionCost) * QuantityOrdered), 2) AS total_profit,
  ROUND(SUM(QuantityOrdered * UnitSalePrice), 2) AS total_revenue,
  ROUND(SUM(QuantityOrdered * UnitProductionCost), 2) AS total_cost
FROM sales_data
GROUP BY ProductCode
ORDER BY total_profit DESC
LIMIT 10;

-- 🚚 Evaluate operational efficiency by measuring delivery time in days
SELECT
  BranchCode,
  ROUND(AVG(JULIANDAY(DeliveryDate) - JULIANDAY(DispatchDate)), 2) AS avg_delivery_days,
  COUNT(*) AS total_orders
FROM sales_data
WHERE DeliveryDate IS NOT NULL AND DispatchDate IS NOT NULL
GROUP BY BranchCode
ORDER BY avg_delivery_days;

-- 💼 Assess sales representatives by revenue and how much discount they give
SELECT
  SalesRepID,
  ROUND(SUM(QuantityOrdered * UnitSalePrice), 2) AS total_revenue,
  ROUND(SUM(QuantityOrdered * UnitSalePrice * DiscountRate), 2) AS total_discount_given,
  COUNT(DISTINCT CustomerID) AS served_customers
FROM sales_data
GROUP BY SalesRepID
ORDER BY total_revenue DESC;

-- 🔁 How many customers placed more than one order?
SELECT
  COUNT(*) * 100.0 / (SELECT COUNT(DISTINCT CustomerID) FROM sales_data) AS repeat_customer_percentage
FROM (
  SELECT CustomerID
  FROM sales_data
  GROUP BY CustomerID
  HAVING COUNT(DISTINCT InvoiceNumber) > 1
);

-- 📈 Financial health: Revenue vs cost per month
SELECT
  DATE(SalesOrderDate, 'start of month') AS month,
  ROUND(SUM((UnitSalePrice - UnitProductionCost) * QuantityOrdered), 2) AS gross_profit,
  ROUND(SUM(UnitSalePrice * QuantityOrdered), 2) AS revenue,
  ROUND(SUM(UnitProductionCost * QuantityOrdered), 2) AS production_cost,
  ROUND(
    SUM((UnitSalePrice - UnitProductionCost) * QuantityOrdered) * 100.0 /
    NULLIF(SUM(UnitSalePrice * QuantityOrdered), 0), 2
  ) AS gross_margin_percent
FROM sales_data
GROUP BY month
ORDER BY month;
