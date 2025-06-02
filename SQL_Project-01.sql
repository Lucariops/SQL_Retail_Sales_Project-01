-- Retail Sales Analysis Project - 01

-- Database Setup

CREATE DATABASE SQL_Project-01;

DROP TABLE IF EXISTS Retail_Sales;

CREATE TABLE Retail_Sales (
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
	gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
	clogs FLOAT,
    total_sale FLOAT
);

-- View Table
SELECT * FROM Retail_Sales;

-- Data Exploration & Cleaning

SELECT COUNT(*) AS total_rows FROM Retail_Sales;
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM Retail_sales;
SELECT DISTINCT category FROM Retail_sales;

SELECT * 
FROM Retail_Sales 
WHERE transaction_id IS NULL 
   OR sale_date IS NULL 
   OR sale_time IS NULL 
   OR customer_id IS NULL 
   OR gender IS NULL 
   OR age IS NULL 
   OR category IS NULL 
   OR quantity IS NULL 
   OR price_per_unit IS NULL 
   OR clogs IS NULL 
   OR total_sale IS NULL;

DELETE FROM Retail_Sales 
WHERE transaction_id IS NULL 
   OR sale_date IS NULL 
   OR sale_time IS NULL 
   OR customer_id IS NULL 
   OR gender IS NULL 
   OR age IS NULL 
   OR category IS NULL 
   OR quantity IS NULL 
   OR price_per_unit IS NULL 
   OR clogs IS NULL 
   OR total_sale IS NULL;

-- Data Analysis & Findings

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05':
SELECT *
FROM Retail_Sales 
WHERE sale_date = '2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is greater or equal to 4 in the month of Nov-2022:
SELECT * 
FROM Retail_Sales 
WHERE category = 'Clothing' 
  AND quantity >= 4 
  AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT category, SUM(total_sale) AS total_sales
FROM Retail_Sales
GROUP BY category;

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT AVG(age) AS average_age
FROM Retail_Sales
WHERE category = 'Beauty';

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT * 
FROM Retail_Sales 
WHERE total_sale > 1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT category, gender, COUNT(transaction_id) AS total_transactions
FROM Retail_Sales
GROUP BY category, gender;

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
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
FROM Retail_Sales
GROUP BY 1, 2
ORDER BY 1, 2, 3
) as t1
WHERE rank = 1

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales:
SELECT customer_id, SUM(total_sale) AS total_sales
FROM Retail_Sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM Retail_Sales
GROUP BY category;

-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
SELECT 
    CASE 
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(transaction_id) AS order_count
FROM Retail_Sales
GROUP BY shift
ORDER BY order_count DESC;

-- Project End --
