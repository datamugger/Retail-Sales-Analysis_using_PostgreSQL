-- SQL Data Analysis Portfolio Project - RETAIL SALES ANALYSIS

-- DDL Script:

DROP TABLE IF EXISTS retail_sales;

Create table retail_sales
(
	transaction_id INT Primary Key,
	sale_date DATE,                  -- YYYY/MM/DD
	sale_time TIME,                  -- HH:MM:SS
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),            -- run this in formula to know about the length =MAX(LEN(G2:G2001)) = 11
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

SELECT * FROM retail_sales; -- no data is there in the table till now

-- Import the data from csv file

SELECT * FROM retail_sales LIMIT 10;


-- Data Cleaning

-- It is difficult to check null values for all the columns one by one in SQL.
-- That's why many people use pandas for this df.isnull().sum()

SELECT * FROM retail_sales 
WHERE transaction_id IS NULL;

SELECT * FROM retail_sales 
WHERE sale_date IS NULL;

SELECT * FROM retail_sales 
WHERE sale_time IS NULL;

SELECT * FROM retail_sales 
WHERE 
	transaction_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL; -- 13 rows (10 rows in 'age' column and 3 rows in 'quantity' column)
	
-- W can either replace null with appropriate values or delete it.

-- Deleting rows where quantity is null (because we have null records for many columns in a row)
DELETE FROM retail_sales
WHERE
	transaction_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;	
	

-- Data Exploration

-- How much records we've?
SELECT 
	COUNT(*) AS total_record
FROM retail_sales;  -- 1997 rows

-- What are the categories we've?
SELECT
	DISTINCT category AS Category
FROM retail_sales;

-- How many categories we've?
SELECT
	COUNT(DISTINCT category) AS Category
FROM retail_sales;

-- How many customers we've?
SELECT
	COUNT(DISTINCT customer_id) AS Customer_count
FROM retail_sales;

-- What is the customer districution along gender?
SELECT
	gender, COUNT(customer_id) AS Customer_count
FROM retail_sales
GROUP BY gender;

-- How much sales we've?
SELECT SUM(total_sale)
FROM retail_sales;

-- Sales by Category
SELECT category, SUM(total_sale) 
FROM retail_sales
GROUP BY category;

-- Order by Category
SELECT category, SUM(quantity) 
FROM retail_sales
GROUP BY category;

  
-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more or equal to 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

Select * from retail_sales;

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05'; -- 11 rows


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and 
--     the quantity sold is more or equal to 4 in the month of Nov-2022

Select * from retail_sales;
select month('2022-11-22');
select extract(month from '2022-11-22'::date);
select DATE_PART(month, '2022-11-22');

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND quantity >= 4
AND EXTRACT(MONTH FROM sale_date) = 11
AND EXTRACT(YEAR FROM sale_date) = 2022;


SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4;


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category, SUM(total_sale) AS Total_Sale
FROM retail_sales
GROUP BY 1;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT ROUND(AVG(age),2) AS Avg_age
FROM retail_sales
WHERE category = 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT *
FROM retail_sales
WHERE total_sale > 1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made 
--    by each gender in each category.

SELECT category, gender, COUNT(transaction_id) AS Transaction_count
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;


-- Q.7 Write a SQL query to calculate the average sale for each month. 
--     Find out best selling month in each year

-- average sale for each month of the year
SELECT 
	EXTRACT(YEAR FROM sale_date),
	DATE_PART('month', sale_date),
	AVG(total_sale)
FROM retail_sales
GROUP BY EXTRACT(YEAR FROM sale_date), DATE_PART('month', sale_date)
ORDER BY 1,2;

-- best selling month in each year
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1



-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

Select * from retail_sales;

SELECT customer_id, SUM(total_sale) 
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

Select * from retail_sales;

SELECT category, COUNT(DISTINCT customer_id) AS Unique_customer
FROM retail_sales
GROUP BY category


-- Q.10 Write a SQL query to create each shift and number of orders 
--     (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

Select * from retail_sales;

WITH CTE AS (
	SELECT transaction_id,sale_time,
		CASE
			WHEN sale_time <= '12:00:00' THEN 'Morning'
			WHEN sale_time > '12:00:00' AND sale_time <= '17:00:00' THEN 'Afternoon'
			ELSE 'Evening'
		END AS Shift
	FROM retail_sales
)
SELECT shift, COUNT(transaction_id) AS Order_count
FROM CTE
GROUP BY shift;



SELECT 
	CASE
		WHEN sale_time <= '12:00:00' THEN 'Morning'
		WHEN sale_time > '12:00:00' AND sale_time <= '17:00:00' THEN 'Afternoon'
		ELSE 'Evening'
	END AS Shift,
	COUNT(transaction_id) AS Order_count
FROM retail_sales
GROUP BY CASE
		WHEN sale_time <= '12:00:00' THEN 'Morning'
		WHEN sale_time > '12:00:00' AND sale_time <= '17:00:00' THEN 'Afternoon'
		ELSE 'Evening'
	END;

-- correct answer
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;

-- End of Project
