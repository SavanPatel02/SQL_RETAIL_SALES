-- SQL RETAIL SALE 

--CREATE TABLE
CREATE TABLE RETAIL (
	TRANSACTIONS_ID INT,
	SALE_DATE DATE,
	SALE_TIME TIME,
	CUSTOMER_ID INT,
	GENDER VARCHAR(15),
	AGE INT,
	CATEGORY VARCHAR(15),
	QUANTIY INT,
	PRICE_PER_UNIT FLOAT,
	COGS FLOAT,
	TOTAL_SALE FLOAT
);


--  TO SEE DATASET
select * from retail
LIMIT 10


-- LENGTH OF THE DATASET
SELECT
	COUNT(*)
FROM
	RETAIL

-- CHECK THE NULL VALUES 
SELECT
	*
FROM
	RETAIL
WHERE
	AGE IS NULL
	OR TRANSACTIONS_ID IS NULL
	OR SALE_TIME IS NULL
	OR SALE_DATE IS NULL
	OR CUSTOMER_ID IS NULL
	OR GENDER IS NULL
	OR CATEGORY IS NULL
	OR QUANTIY IS NULL
	OR PRICE_PER_UNIT IS NULL
	OR COGS IS NULL
	OR TOTAL_SALE IS NULL;

-- FILL NULL VALUES IN AGE
UPDATE RETAIL
SET
	AGE = (
		SELECT
			ROUND(AVG(AGE)::NUMERIC, 0)
		FROM
			RETAIL
		WHERE
			AGE IS NOT NULL
	)
WHERE AGE IS NULL;

-- DELETE OTHER NULL ROWS
DELETE FROM RETAIL
WHERE
	AGE IS NULL
	OR TRANSACTIONS_ID IS NULL
	OR SALE_TIME IS NULL
	OR SALE_DATE IS NULL
	OR CUSTOMER_ID IS NULL
	OR GENDER IS NULL
	OR CATEGORY IS NULL
	OR QUANTIY IS NULL
	OR PRICE_PER_UNIT IS NULL
	OR COGS IS NULL
	OR TOTAL_SALE IS NULL;

-- DATA EXPLORATION

--HOW MANY SALES WE HAVE?
SELECT COUNT(*) AS TOTAL_SALE FROM RETAIL

--HOW MANY UNIQUE CUSTOMERS WE HAVE?
SELECT COUNT(DISTINCT CUSTOMER_ID) AS TOTAL_SALE FROM RETAIL 

--hOW MANY DIFFERENT CATEGORY WE HAVE?
SELECT COUNT(DISTINCT CATEGORY) AS TOTAL_SALE FROM RETAIL 
SELECT DISTINCT CATEGORY AS TOTAL_SALE FROM RETAIL 

-- DATA ANALYSIS & BUSINESS KEY PROBLEMS AND ANSWERS

-- Q1:Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT
	*
FROM
	RETAIL
WHERE
	SALE_DATE = '2022-11-05'

-- Q2:Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT
	*
FROM
	RETAIL
WHERE
	CATEGORY = 'Clothing'
	AND TO_CHAR(SALE_DATE, 'YYYY-MM') = '2022-11' 
	AND QUANTIY>=4;

-- Q3:Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT
	CATEGORY,
	SUM(TOTAL_SALE) AS NET_SALE,
	COUNT(*) AS TOTAL_ORDERS
FROM
	RETAIL
GROUP BY	1

-- Q4: Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT
	ROUND(AVG(AGE),2)
FROM
	RETAIL
WHERE
	CATEGORY = 'Beauty'

-- Q5: Write a SQL query to find all transactions where the total_sale is greater than 1000.:

SELECT
	*
FROM
	RETAIL
WHERE
	TOTAL_SALE > 1000;

--Q6: Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

SELECT
	CATEGORY,
	GENDER,
	COUNT(*) AS TOTAL_TRANS
FROM
	RETAIL
GROUP BY
	CATEGORY,
	GENDER
ORDER BY 1

--Q7:Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT YEAR,MONTH,AVG_SALE FROM
(
SELECT
	EXTRACT(YEAR FROM SALE_DATE)AS YEAR,
	EXTRACT(MONTH FROM SALE_DATE) AS MONTH,
	AVG(TOTAL_SALE) AS AVG_SALE,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM SALE_DATE) ORDER BY AVG(TOTAL_SALE) DESC )
FROM RETAIL
GROUP BY 1,2 
) AS T1
WHERE RANK=1

--Q8 : Write a SQL query to find the top 5 customers based on the highest total sales

SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM RETAIL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q9: Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM RETAIL
GROUP BY category

--Q10: Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM RETAIL
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

-- END OF PROJECT