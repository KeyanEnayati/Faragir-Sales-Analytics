-- Monthly Revenue
SELECT
  DATE_TRUNC('month', SalesOrderDate) AS sale_month,
  SUM(QuantityOrdered * UnitSalePrice) AS total_revenue,
  SUM(QuantityOrdered * UnitProductionCost) AS total_cost,
  SUM(QuantityOrdered * UnitSalePrice) - SUM(QuantityOrdered * UnitProductionCost) AS profit
FROM sales_data
GROUP BY sale_month
ORDER BY sale_month;

-- Top 5 Products
SELECT
  ProductCode,
  SUM(QuantityOrdered * UnitSalePrice) AS revenue
FROM sales_data
GROUP BY ProductCode
ORDER BY revenue DESC
LIMIT 5;

-- Revenue by Branch
SELECT
  BranchCode,
  SUM(QuantityOrdered * UnitSalePrice) AS branch_revenue
FROM sales_data
GROUP BY BranchCode
ORDER BY branch_revenue DESC;
