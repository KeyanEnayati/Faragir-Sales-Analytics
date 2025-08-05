 --Create the main sales table for Faragir Sanat Mehrbin
CREATE TABLE sales_data (
  InvoiceNumber TEXT,
  SalesChannel TEXT,
  WarehouseLocationCode TEXT,
  ProcurementDate TEXT,       -- Stored as string due to datetime format
  SalesOrderDate TEXT,
  DispatchDate TEXT,
  DeliveryDate TEXT,
  Currency TEXT,
  SalesRepID INTEGER,
  CustomerID INTEGER,
  BranchCode TEXT,
  ProductCode INTEGER,
  QuantityOrdered INTEGER,
  DiscountRate REAL,
  UnitSalePrice REAL,
  UnitProductionCost REAL
);