-- 01. Remove rows with NULLs in critical fields
DELETE FROM sales_data
WHERE
  InvoiceNumber IS NULL OR
  SalesOrderDate IS NULL OR
  CustomerID IS NULL OR
  ProductCode IS NULL;

-- 02. Remove rows where price or quantity is zero or negative
DELETE FROM sales_data
WHERE
  UnitSalePrice IS NULL OR UnitSalePrice <= 0 OR
  QuantityOrdered IS NULL OR QuantityOrdered <= 0;

-- 03. Standardise date formats (if any slashes exist, replace with dashes)
-- This is only useful if the data was imported with slashes (e.g., '2018/05/31')
UPDATE sales_data
SET SalesOrderDate = REPLACE(SalesOrderDate, '/', '-')
WHERE SalesOrderDate LIKE '%/%';

-- 04. Trim extra spaces from text fields
UPDATE sales_data
SET
  InvoiceNumber = TRIM(InvoiceNumber),
  SalesChannel = TRIM(SalesChannel),
  WarehouseLocationCode = TRIM(WarehouseLocationCode),
  ProductCode = TRIM(ProductCode),
  ProductGroup = TRIM(ProductGroup),
  ProductCategory = TRIM(ProductCategory),
  ProductSubCategory = TRIM(ProductSubCategory),
  ProductDescription = TRIM(ProductDescription),
  Currency = TRIM(Currency);

-- 05. Remove duplicate rows based on InvoiceNumber + CustomerID + ProductCode
-- Keeps the first occurrence only (based on rowid)
DELETE FROM sales_data
WHERE rowid NOT IN (
  SELECT MIN(rowid)
  FROM sales_data
  GROUP BY InvoiceNumber, CustomerID, ProductCode
);

-- 06. Keep only IRR currency rows (filter out other currencies)
DELETE FROM sales_data
WHERE Currency != 'IRR';

-- 07. Keep only rows within the 2018–2020 range
-- Optional: Adjust this based on project scope
DELETE FROM sales_data
WHERE SalesOrderDate < '2018-01-01' OR SalesOrderDate > '2020-12-31';
