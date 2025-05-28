# Retail Sales SQL Project

## 📌 Project Overview

This **Retail Sales SQL Project** focuses on analyzing transactional data from a retail business using **SQL queries**. It includes **data cleaning**, **exploration**, and **key business insights**, helping stakeholders make informed decisions based on customer behavior and sales patterns.

---

## 🗃️ Dataset Description

The dataset is stored in a table named `RETAIL` with the following columns:

* **TRANSACTIONS\_ID** *(INT)* – Unique transaction identifier
* **SALE\_DATE** *(DATE)* – Date of transaction
* **SALE\_TIME** *(TIME)* – Time of transaction
* **CUSTOMER\_ID** *(INT)* – Unique customer ID
* **GENDER** *(VARCHAR)* – Gender of customer
* **AGE** *(INT)* – Age of customer
* **CATEGORY** *(VARCHAR)* – Product category (e.g., Clothing, Beauty)
* **QUANTIY** *(INT)* – Quantity sold
* **PRICE\_PER\_UNIT** *(FLOAT)* – Unit price
* **COGS** *(FLOAT)* – Cost of goods sold
* **TOTAL\_SALE** *(FLOAT)* – Total sale amount

---

## 🧹 Data Cleaning

1. **Null Value Detection**: Checked for null values across all columns.
2. **Imputation**: Missing `AGE` values filled with the rounded average age.
3. **Deletion**: All remaining null rows removed to ensure data integrity.

---

## 🔍 Data Exploration

* Total number of sales
* Total unique customers
* Total unique categories

---

## 📈 Business Analysis (Key Queries)

### Q1. Sales on Specific Date

**Query:**

```sql
SELECT *
FROM RETAIL
WHERE SALE_DATE = '2022-11-05';
```

### Q2. High Quantity Clothing Sales in November 2022

**Query:**

```sql
SELECT *
FROM RETAIL
WHERE CATEGORY = 'Clothing'
  AND TO_CHAR(SALE_DATE, 'YYYY-MM') = '2022-11'
  AND QUANTIY >= 4;
```

### Q3. Total Sales by Category

**Query:**

```sql
SELECT CATEGORY,
       SUM(TOTAL_SALE) AS NET_SALE,
       COUNT(*) AS TOTAL_ORDERS
FROM RETAIL
GROUP BY CATEGORY;
```

### Q4. Average Age of Beauty Category Customers

**Query:**

```sql
SELECT ROUND(AVG(AGE), 2) AS AVERAGE_AGE
FROM RETAIL
WHERE CATEGORY = 'Beauty';
```

### Q5. Transactions with Total Sale > 1000

**Query:**

```sql
SELECT *
FROM RETAIL
WHERE TOTAL_SALE > 1000;
```

### Q6. Transactions by Gender in Each Category

**Query:**

```sql
SELECT CATEGORY,
       GENDER,
       COUNT(*) AS TOTAL_TRANS
FROM RETAIL
GROUP BY CATEGORY, GENDER
ORDER BY CATEGORY;
```

### Q7. Best Selling Month Each Year (Avg Sale)

**Query:**

```sql
SELECT YEAR, MONTH, AVG_SALE
FROM (
  SELECT EXTRACT(YEAR FROM SALE_DATE) AS YEAR,
         EXTRACT(MONTH FROM SALE_DATE) AS MONTH,
         AVG(TOTAL_SALE) AS AVG_SALE,
         RANK() OVER(PARTITION BY EXTRACT(YEAR FROM SALE_DATE)
                    ORDER BY AVG(TOTAL_SALE) DESC) AS RANK
  FROM RETAIL
  GROUP BY 1, 2
) AS T1
WHERE RANK = 1;
```

### Q8. Top 5 Customers by Total Sales

**Query:**

```sql
SELECT CUSTOMER_ID,
       SUM(TOTAL_SALE) AS TOTAL_SALES
FROM RETAIL
GROUP BY CUSTOMER_ID
ORDER BY TOTAL_SALES DESC
LIMIT 5;
```

### Q9. Unique Customers by Category

**Query:**

```sql
SELECT CATEGORY,
       COUNT(DISTINCT CUSTOMER_ID) AS CNT_UNIQUE_CS
FROM RETAIL
GROUP BY CATEGORY;
```

### Q10. Orders by Time Shift

**Query:**

```sql
WITH hourly_sale AS (
  SELECT *,
         CASE
           WHEN EXTRACT(HOUR FROM SALE_TIME) < 12 THEN 'Morning'
           WHEN EXTRACT(HOUR FROM SALE_TIME) BETWEEN 12 AND 17 THEN 'Afternoon'
           ELSE 'Evening'
         END AS shift
  FROM RETAIL
)
SELECT shift,
       COUNT(*) AS TOTAL_ORDERS
FROM hourly_sale
GROUP BY shift;
```

---

## 📊 Tools Used

* **SQL** (PostgreSQL or compatible engine)
* Any SQL client or database management tool (pgAdmin, MySQL Workbench, DBeaver, etc.)

---

## ✅ How to Use

1. Create the `RETAIL` table using the provided schema.
2. Import your retail dataset into the table.
3. Run the SQL queries in the respective order.
4. Modify and extend queries to suit your analysis needs.

---

## 💡 Insights & Applications

* Understand customer behavior by age and gender.
* Identify top-performing product categories and customers.
* Determine peak sales hours for optimized staffing and inventory.

---

## 📁 File Structure

```
RETAIL_SALE.sql   # Main SQL file with schema, cleaning, and analysis queries
```

---

## 📬 Contact

For queries or suggestions, feel free to reach out via GitHub Issues.

> **Author**: \[SAVAN PATEL]
