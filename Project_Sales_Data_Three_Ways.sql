/**
This analysis of electronics, appliances and accessories sales data from the USA, derived from twelve Kaggle
CSV files spanning the entirety of 2019, was conducted to answer the files' associated series of questions
(updated slightly to reflect different/additional queries):

What was the total sales amount for that year?
What was the best month for sales? How much was earned that month?
Which state had the highest total sales? How much?
Which city had the highest number of sales?
What time should we display advertisements to maximise the likelihood of customers buying products?
Which category of products is sold most often?
Which category of products generated the highest sales? How much?
Which product sold the most? Why do you think it sold the most?

The analysis was carried out entirely within SQL with additional intentions to 'serve the data'
with two additional options: Excel and Power BI.
**/


-- Query data in month tables following import.
SELECT TOP(10) *
FROM Project_Sales_Data_Three_Ways..sales_january_2019;


/**
Union the 12 month tables, thereby removing duplicates. 
Create table of joined month tables.
**/
SELECT * INTO Project_Sales_Data_Three_Ways..sales_data FROM 
(
    SELECT *
	FROM Project_Sales_Data_Three_Ways..sales_january_2019
	UNION
    SELECT *
	FROM Project_Sales_Data_Three_Ways..sales_february_2019
	UNION
    SELECT *
	FROM Project_Sales_Data_Three_Ways..sales_march_2019
	UNION
    SELECT *
	FROM Project_Sales_Data_Three_Ways..sales_april_2019
	UNION
    SELECT *
	FROM Project_Sales_Data_Three_Ways..sales_may_2019
	UNION
    SELECT *
	FROM Project_Sales_Data_Three_Ways..sales_june_2019
	UNION
    SELECT *
	FROM Project_Sales_Data_Three_Ways..sales_july_2019
	UNION
    SELECT *
	FROM Project_Sales_Data_Three_Ways..sales_august_2019
	UNION
    SELECT *
	FROM Project_Sales_Data_Three_Ways..sales_september_2019
	UNION
    SELECT *
	FROM Project_Sales_Data_Three_Ways..sales_october_2019
	UNION
    SELECT *
	FROM Project_Sales_Data_Three_Ways..sales_november_2019
	UNION
    SELECT *
	FROM Project_Sales_Data_Three_Ways..sales_december_2019
) AS sales_data_temp;


-- Query data in sales_data table following union and creation.
SELECT TOP(10) *
FROM Project_Sales_Data_Three_Ways..sales_data
ORDER BY [Order ID];
-- FINDINGS: Non-numerical Order IDs ('Order ID', blank) found when changing order by direction.


-- Count rows with invalid Order IDs.
SELECT COUNT(*)
FROM Project_Sales_Data_Three_Ways..sales_data
WHERE [Order ID] = ' ' OR [Order ID] = 'Order ID';
-- FINDINGS: Two rows.


-- Delete two rows identified in previous query.
DELETE
FROM Project_Sales_Data_Three_Ways..sales_data
WHERE [Order ID] = ' ' OR [Order ID] = 'Order ID';


-- Count rows with years outside of 2019.
SELECT COUNT(*)
FROM Project_Sales_Data_Three_Ways..sales_data
WHERE [Order Date] NOT LIKE '%/19 %';
-- FINDINGS: 34 rows.


-- Delete rows identified in previous query.
DELETE
FROM Project_Sales_Data_Three_Ways..sales_data
WHERE [Order Date] NOT LIKE '%/19 %';


-- Convert data types for possible aggegrations.
ALTER TABLE Project_Sales_Data_Three_Ways..sales_data
    ALTER COLUMN [Quantity Ordered] INT NULL
ALTER TABLE Project_Sales_Data_Three_Ways..sales_data
	ALTER COLUMN [Price Each] FLOAT NULL;


-- QUESTION: What was the total sales amount for that year?
SELECT ROUND(SUM(sales),0)
FROM (
	SELECT CONVERT(FLOAT,[Quantity Ordered]) * [Price Each] AS sales
	FROM Project_Sales_Data_Three_Ways..sales_data
) AS total_sales;
-- FINDINGS: $34,456,868


-- QUESTION: What was the best month for sales? How much was earned that month?
SELECT 
	month,
	ROUND(SUM(sales),0) AS total_sales
FROM (
	SELECT 
		MONTH(CONVERT(DATE,[Order Date])) AS month,
		CONVERT(FLOAT,[Quantity Ordered]) * [Price Each] AS sales
	FROM Project_Sales_Data_Three_Ways..sales_data
	) AS row_sales
GROUP BY month
ORDER BY total_sales DESC;
-- FINDINGS: December, $4,608,296


-- QUESTION: Which state had the highest total sales? How much?
WITH get_state_sales AS (
	SELECT
		SUBSTRING([Purchase Address], LEN([Purchase Address]) - 8, 2) AS sale_state,
		CONVERT(FLOAT,[Quantity Ordered]) * [Price Each] AS row_sales
	FROM Project_Sales_Data_Three_Ways..sales_data
	)

SELECT
	sale_state,
	ROUND(SUM(row_sales),0) AS total_state_sales
FROM get_state_sales
GROUP BY sale_state
ORDER BY total_state_sales DESC;
--FINDINGS: California, $13,699,563


-- QUESTION: Which city had the highest number of sales?
WITH get_city_orders AS (
	SELECT 
		SUBSTRING([Purchase Address], charindex(', ', [Purchase Address]) + 1, LEN([Purchase Address]) - 10 - (charindex(', ', [Purchase Address]) + 1)) AS sale_city,
		[Quantity Ordered] AS city_orders
	FROM Project_Sales_Data_Three_Ways..sales_data
	)
	
SELECT
	sale_city,
	COUNT(city_orders) AS total_city_orders
FROM get_city_orders
GROUP BY sale_city
ORDER BY total_city_orders DESC;
--FINDINGS: San Francisco, CA


-- QUESTION: What time should we display advertisements to maximise the likelihood of customers buying products?
SELECT 
	hour,
	COUNT([Quantity Ordered]) AS number_sales
FROM (
	SELECT
		DATEPART(HOUR,(CONVERT(DATETIME,[Order Date]))) AS hour,
		[Quantity Ordered]
	FROM Project_Sales_Data_Three_Ways..sales_data
	) AS get_hour
GROUP BY hour
ORDER BY number_sales DESC;
/** 
FINDINGS: Two peaks were identified at 12pm and 7pm. Advertising around 9am-10am to coincide with
mid-morning breaks, as well as around 5pm-6pm to coincide with post-work breaks, may reach the highest
number of potential customers engaging in online shopping.
**/


/**
QUESTION: Which category of products is sold most often?
Check array of products sold to define categories.
**/
SELECT DISTINCT Product
FROM Project_Sales_Data_Three_Ways..sales_data;

-- Count orders of each product while applying categories.
WITH group_products AS (
	SELECT
		SUM(CASE WHEN Product LIKE '%Batteries%' THEN [Quantity Ordered] ELSE 0 END) AS batteries,
		SUM(CASE WHEN Product LIKE '%Headphones' THEN [Quantity Ordered] ELSE 0 END) AS headphones,
		SUM(CASE WHEN Product LIKE '%Cable' THEN [Quantity Ordered]  ELSE 0 END) AS cables,
		SUM(CASE WHEN Product LIKE '%Monitor' THEN [Quantity Ordered]  ELSE 0 END) AS monitors,
		SUM(CASE WHEN Product LIKE '%Laptop' THEN [Quantity Ordered]  ELSE 0 END) AS laptops,
		SUM(CASE WHEN Product LIKE '% Phone' OR Product LIKE 'iPhone' THEN [Quantity Ordered]  ELSE 0 END) AS phones,
		SUM(CASE WHEN Product LIKE '%TV' THEN [Quantity Ordered]  ELSE 0 END) AS televisions,
		SUM(CASE WHEN Product LIKE '%Machine' OR Product LIKE '%Dryer' THEN [Quantity Ordered] ELSE 0 END) AS home_appliances
	FROM Project_Sales_Data_Three_Ways..sales_data
	GROUP BY Product
	)

-- Sum the number of orders within each category.
SELECT
	SUM(batteries) AS batteries_ordered,
	SUM(headphones) AS headphones_ordered,
	SUM(cables) AS cables_ordered,
	SUM(monitors) AS monitors_ordered,
	SUM(laptops) AS laptops_ordered,
	SUM(phones) AS phones_ordered,
	SUM(televisions) AS televisions_ordered,
	SUM(home_appliances) AS home_appliances_ordered
FROM group_products;
--FINDINGS: Batteries


-- QUESTION: Which category of products generated the highest sales? How much?
WITH group_products AS (
	SELECT
		SUM(CASE WHEN Product LIKE '%Batteries%' THEN ROUND(CONVERT(FLOAT,[Quantity Ordered]) * [Price Each],0) ELSE 0 END) AS batteries,
		SUM(CASE WHEN Product LIKE '%Headphones' THEN ROUND(CONVERT(FLOAT,[Quantity Ordered]) * [Price Each],0) ELSE 0 END) AS headphones,
		SUM(CASE WHEN Product LIKE '%Cable' THEN ROUND(CONVERT(FLOAT,[Quantity Ordered]) * [Price Each],0)  ELSE 0 END) AS cables,
		SUM(CASE WHEN Product LIKE '%Monitor' THEN ROUND(CONVERT(FLOAT,[Quantity Ordered]) * [Price Each],0)  ELSE 0 END) AS monitors,
		SUM(CASE WHEN Product LIKE '%Laptop%' THEN ROUND(CONVERT(FLOAT,[Quantity Ordered]) * [Price Each],0)  ELSE 0 END) AS laptops,
		SUM(CASE WHEN Product LIKE '% Phone' OR Product LIKE 'iPhone' THEN ROUND(CONVERT(FLOAT,[Quantity Ordered]) * [Price Each],0)  ELSE 0 END) AS phones,
		SUM(CASE WHEN Product LIKE '%TV' THEN ROUND(CONVERT(FLOAT,[Quantity Ordered]) * [Price Each],0)  ELSE 0 END) AS televisions,
		SUM(CASE WHEN Product LIKE '%Machine' OR Product LIKE '%Dryer' THEN ROUND(CONVERT(FLOAT,[Quantity Ordered]) * [Price Each],0) ELSE 0 END) AS home_appliances
	FROM Project_Sales_Data_Three_Ways..sales_data
	GROUP BY Product
	)

-- Sum the number of orders within each category.
SELECT
	SUM(batteries) AS batteries_sales,
	SUM(headphones) AS headphones_sales,
	SUM(cables) AS cables_sales,
	SUM(monitors) AS monitors_sales,
	SUM(laptops) AS laptops_sales,
	SUM(phones) AS phones_sales,
	SUM(televisions) AS televisions_sales,
	SUM(home_appliances) AS home_appliances_sales
FROM group_products;
-- FINDINGS: Laptops, $12,156,800


-- QUESTION: Which product sold the most? Why do you think it sold the most?
SELECT 
	Product,
	SUM([Quantity Ordered]) AS total_number_ordered
FROM Project_Sales_Data_Three_Ways..sales_data
GROUP BY Product
ORDER BY total_number_ordered DESC;
/** FINDINGS: AAA batteries (4-pack), followed by AA batteries (4-pack), charging cables and headphones.
These products are the cheapest in the list and are also known to run out or failure regularly.
**/
