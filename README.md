# 📈 Faragir Sanat Mehrbin Sales Performance & Customer Segmentation Dashboard (2018–2020)

---

## 🔖 Project Overview

This project presents a comprehensive analysis of sales performance and customer behavior for Faragir Sanat Mehrbin, a laboratory equipment manufacturing company. The objective is to clean raw transactional data, generate actionable KPIs, and create segmentation and trend insights that can drive business decisions.

Using SQL, we processed and analyzed 3 years of transaction-level data (2018–2020), building views and reports for integration into dashboards (Power BI / Excel). Final outputs were saved as `.xlsx` files and structured for business intelligence reporting.

---

## 📂 Dataset & Table Structure

The dataset was imported into a SQL database and structured using the following table:

```sql
CREATE TABLE sales_data (
  InvoiceNumber TEXT,
  SalesChannel TEXT,
  WarehouseLocationCode TEXT,
  ProcurementDate TEXT,
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
```

---

## 🧹 Data Cleaning Pipeline (Steps 01–07)

The raw data underwent structured cleaning:

```sql
-- 01: Remove rows with NULLs in key columns
DELETE FROM sales_data
WHERE InvoiceNumber IS NULL OR SalesOrderDate IS NULL OR CustomerID IS NULL OR ProductCode IS NULL;

-- 02: Remove rows with zero or negative price/quantity
DELETE FROM sales_data
WHERE UnitSalePrice <= 0 OR QuantityOrdered <= 0;

-- 03: Standardize date format
UPDATE sales_data
SET SalesOrderDate = REPLACE(SalesOrderDate, '/', '-')
WHERE SalesOrderDate LIKE '%/%';

-- 04: Trim text fields
UPDATE sales_data
SET InvoiceNumber = TRIM(InvoiceNumber), ... ;

-- 05: Remove duplicate rows
DELETE FROM sales_data
WHERE rowid NOT IN (
  SELECT MIN(rowid)
  FROM sales_data
  GROUP BY InvoiceNumber, CustomerID, ProductCode
);

-- 06: Keep only rows in IRR currency
DELETE FROM sales_data
WHERE Currency != 'IRR';

-- 07: Filter to date range (2018-2020)
DELETE FROM sales_data
WHERE SalesOrderDate < '2018-01-01' OR SalesOrderDate > '2020-12-31';
```

**📄 Output**: Cleaned dataset saved to: `sales KPI.xlsx`

---
## 📊 Sales KPIs Analysis

Understanding key performance indicators (KPIs) is crucial for any business. For **Faragir Sanat Mehrbin**, we calculated foundational KPIs using SQL to assess:

- Order volume  
- Customer base  
- Revenue  
- Average order size  

---

### 🧮 Code: Overall KPIs

```sql
-- Overall KPIs: Total Orders, Unique Customers, Revenue & AOV
SELECT
  COUNT(DISTINCT InvoiceNumber) AS total_orders,
  COUNT(DISTINCT CustomerID) AS unique_customers,
  ROUND(SUM(QuantityOrdered * UnitSalePrice), 2) AS total_revenue,
  ROUND(AVG(QuantityOrdered * UnitSalePrice), 2) AS avg_order_value
FROM sales_data;
```

---

### 📎 Output :

<details>
<summary>📊 Output Preview: Click to expand</summary>

<div style="overflow-x: auto">

| total_orders | unique_customers | total_revenue   | avg_order_value |
|--------------|------------------|------------------|-----------------|
| 7991         | 999              | 82,692,726.60    | 10,348.23       |

</div>
</details>

---

### 📊 Revenue Breakdown by Sales Channel

Understanding the revenue contribution of each sales channel enables **Faragir Sanat Mehrbin** to optimize resource allocation and tailor sales strategies. This section calculates the number of orders and total revenue per channel.

---

### 🧮 Code

```sql
-- Revenue Breakdown by Sales Channel
SELECT
  SalesChannel,
  COUNT(*) AS total_orders,
  ROUND(SUM(QuantityOrdered * UnitSalePrice), 2) AS revenue
FROM sales_data
GROUP BY SalesChannel
ORDER BY revenue DESC;
```

---

### 📎 Output:

<details>
<summary>📊 Output </summary>

<div style="overflow-x: auto">

| SalesChannel  | total_orders | revenue        |
|---------------|--------------|----------------|
| Distributor   | 2,038        | 21,388,088.40  |
| Online        | 2,041        | 20,943,617.10  |
| Agency        | 1,952        | 20,248,639.50  |
| Direct Sales  | 1,960        | 20,112,381.60  |

</div>
</details>

📁 **Full dataset available in** `sales KPI .xlsx` → **Sheet:** `Sales Channel Revenue`

### 📅 Monthly Revenue Aggregation

Analyzing revenue trends over time helps Faragir Sanat Mehrbin identify seasonality, growth periods, and periods requiring strategic intervention. This query aggregates total monthly revenue based on the `SalesOrderDate`.

---

### 🧮 Code

```sql
-- Monthly Revenue Trend
SELECT
  SUBSTR(SalesOrderDate, 1, 7) AS month,
  ROUND(SUM(QuantityOrdered * UnitSalePrice), 2) AS monthly_revenue
FROM sales_data
GROUP BY month
ORDER BY month;
```

---

### 📎 Output:

<details>
<summary>📊 Output Preview: Click to expand</summary>

<div style="overflow-x: auto">

| month     | monthly_revenue |
|-----------|------------------|
| 2018-05   | 75629.6   |
| 2018-06   | 2454752.7  |
| 2018-07  | 2707550.4    |
| ...       | ...           |
| 2020-11   | 2977607.3     |
| 2020-12   | 3046617.3     |

</div>
</details>

📁 **Full dataset available in** `sales KPI .xlsx` → **Sheet:** `Monthly Revenue`
