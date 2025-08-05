-- Remove bad rows
DELETE FROM sales_data
WHERE InvoiceNumber IS NULL OR UnitSalePrice <= 0;

-- Standardize sales channel text
UPDATE sales_data
SET SalesChannel = TRIM(LOWER(SalesChannel));
