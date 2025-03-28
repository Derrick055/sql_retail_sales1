CREATE DATABASE sql_project_p1;

-- Create Tabel
CREATE TABLE retail_sales
	 ( 
		 transactions_id INT PRIMARY KEY,
		 sale_date DATE,
		 sale_time TIME,
		 customer_id INT,
		 gender VARCHAR(15),
		 age INT,
		 category VARCHAR(15),
		 quantiy INT,
		 price_per_unit FLOAT,
		 cogs FLOAT,
		total_sale FLOAT
     );  	
     
SELECT *
FROM sales
LIMIT 10;

SELECT COUNT(*) 
FROM retail_sales;

-- FINDING NULL VALUES
SELECT * FROM retail_sales
WHERE 
     transactions_id IS NULL
     OR sale_date IS NULL
     OR sale_time IS NULL
     OR customer_id IS NULL
     OR gender IS NULL
     OR category IS NULL
     OR quantiy IS NULL
     OR price_per_unit IS NULL
     OR cogs IS NULL
     OR total_sale IS NULL;
     
     -- DATA EXPLORATION
     -- HOW MANY UNIQUE CUSTOMERS DO WE HAVE
     SELECT COUNT(DISTINCT customer_id) 
     FROM retail_sales;
     
     -- HOW MANY UNIQUE CATEGORIES DO WE HAVE
     SELECT DISTINCT category
     FROM retail_sales;
     
     -- data analysis & business key problems
     -- Q1 Write a query to retrieve all the columns for sales made on '2022-11-05'
     SELECT *
     FROM retail_sales
     WHERE sale_date = '2022-11-05';
     
     -- Q2 Write a query to retrieve all transactions where category is clothing and quantity sold is more than 4 in the month of NOV -2022
     SELECT *
     FROM retail_sales
     WHERE category = 'Clothing' 
     AND date_format(sale_date, '%Y-%m') = '2022-11'
     AND quantiy >= 4
     GROUP BY 1;
     
     -- WRITE A QUERY TO CALCULATE THE TOTAL SALES FOR EACH CATEGORY
     SELECT 
         category,
         SUM(total_sale) Total_sales,
         COUNT(*) AS Total_ordered
	FROM retail_sales
    GROUP BY category;
    
    -- WRITE A QUERY TO FIND THE AVERAGE AGE OF CUSTOMERS WHO PURCHASED ITEMS FROM THE BEAUTY CATEGORY
   SELECT
          ROUND(AVG(age),2) AS AVG_AGE
   FROM retail_sales
   WHERE category = 'beauty';
   
   -- WRITE A QUERY TO FIND ALL TRANSACTIONS WHERE THE TOTAL_SALE IS GREATER THAN 1000
   SELECT *
   FROM retail_sales
   WHERE total_sale > 1000;
   
   -- WRITE A SQL QUERY TO FIND THE TOTAL NUMBER OF TRANSACTIONS MADE BY EACH GENDER IN A CATEGORY
   SELECT
          category,
          gender,
          COUNT(transactions_id) AS Total_transactions
   FROM retail_sales
   GROUP BY category,gender
   ORDER BY 1;
   
   -- WRITE A SQL QUERY TO CALCULATE THE AVERAGE SALE FOR EACH MONTH.FIND OUT BEST SELLING MONTH IN EACH YEAR.
   SELECT *
   FROM(
   SELECT 
        YEAR(sale_date) AS Year,
        Month(sale_date) AS Month,
        ROUND(AVG(total_sale),2) AS Total_sales,
        RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale)  DESC) AS RANKS
FROM retail_sales
   GROUP BY 1,2
		)AS Table1
	WHERE RANKS = 1;
   -- ORDER BY 1,2,3 DESC; 
  
  -- WRITE A QUERY TO FIND THE 5 TOP CUSTOMERS BASED ON TOTAL SALES.	
  SELECT 
       customer_id,
       SUM(total_sale) AS Total_purchased
  FROM retail_sales
  GROUP BY 1
  ORDER BY 2 DESC
  LIMIT 5;
  
  -- WRITE A QUERY TO FIND THE NUMBER OF UNIQUE CUSTOMERS WHO BOUGHT ITEM FROM EACH CATEGORY.
  SELECT 
        category,
         COUNT(DISTINCT customer_id) AS Unique_customers
  FROM retail_sales
  GROUP BY 1;
   
-- WRITE A QUERY TO CREATE SHIFT PATTERN BASED SALE_TIME AND NUMBER OF ORDERS 
WITH hourly_sales -- THIS STYLE IS CALLED CTE
AS 
(
SELECT *,
       CASE
           WHEN HOUR(sale_time) < 12 THEN 'Morning'
           WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		   ELSE 'Evening'
	   END AS Shift_Pattern
FROM retail_sales
)
SELECT 
     shift_Pattern,
     COUNT(*) AS No_orders
FROM hourly_sales
GROUP BY 1;

-- END OF PROJECT

