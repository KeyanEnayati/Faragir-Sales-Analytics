CREATE TABLE sales_data (
  InvoiceNumber VARCHAR(20),
  SalesChannel VARCHAR(50),
  WarehouseLocationCode VARCHAR(20),
  ProcurementDate DATE,
  SalesOrderDate DATE,
  DispatchDate DATE,
  DeliveryDate DATE,
  Currency VARCHAR(10),
  SalesRepID INT,
  CustomerID INT,
  BranchCode VARCHAR(10),
  ProductCode INT,
  QuantityOrdered INT,
  DiscountRate FLOAT,
  UnitSalePrice FLOAT,
  UnitProductionCost FLOAT
);
