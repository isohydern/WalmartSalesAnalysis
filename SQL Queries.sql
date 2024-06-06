--Create Database in SQL Server, name as SalesDataWalmart
--Right click database and add task import data
--Use Sql Server import data wizard
--Use flat file 
--Identified CSV file
--Destination, choose Microsoft OLE DB Provider for SQL Server
--Import File

-- Select all data from sales
SELECT * FROM [dbo].[WalmartSalesData];

--Add new column name time_of_day
ALTER TABLE [dbo].[WalmartSalesData] ADD time_of_day VARCHAR(20);

--Populate column time_of_day wwith this query
UPDATE [dbo].[WalmartSalesData]
SET time_of_day = CASE
    WHEN time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
    WHEN time BETWEEN '12:00:00' AND '16:00:00' THEN 'Afternoon'
    ELSE 'Evening'
END;

--check table adjustment
SELECT * FROM [dbo].[WalmartSalesData];

--Add new column name day_name
ALTER TABLE [dbo].[WalmartSalesData] ADD day_name VARCHAR(10);

--Populate column day_name wwith this query
UPDATE [dbo].[WalmartSalesData]
SET day_name = DATENAME(WEEKDAY, date);

--Add new column name month_name
ALTER TABLE [dbo].[WalmartSalesData] ADD month_name VARCHAR(10);

--Populate column month_name wwith this query
UPDATE [dbo].[WalmartSalesData]
SET month_name = DATENAME(MONTH, date);

--check table adjustment
SELECT * FROM [dbo].[WalmartSalesData];

--Data Analysis Queries--

--Finding Unique Cities:
SELECT DISTINCT city FROM [dbo].[WalmartSalesData];


--Finding City and Branch:
SELECT DISTINCT city, branch FROM [dbo].[WalmartSalesData];


--Finding Unique Product Lines:
SELECT DISTINCT [Product line] FROM [dbo].[WalmartSalesData];


--Finding Most Selling Product Line:
SELECT
    [Product line],
    SUM(CONVERT(int,quantity)) AS qty
FROM [dbo].[WalmartSalesData]
GROUP BY [Product line]
ORDER BY qty DESC;

--Finding Total Revenue by Month:
SELECT
    month_name AS month,
    SUM(Convert(float,total)) AS total_revenue
FROM [dbo].[WalmartSalesData]
GROUP BY month_name
ORDER BY total_revenue DESC;

-- Finding Month with Largest COGS:
SELECT
    month_name AS month,
    SUM(convert(float,cogs)) AS cogs
FROM [dbo].[WalmartSalesData]
GROUP BY month_name
ORDER BY cogs DESC;

--Finding Product Line with Largest Revenue:
SELECT
    [Product line],
    SUM(Convert(float,total)) AS total_revenue
FROM [dbo].[WalmartSalesData]
GROUP BY  [Product line]
ORDER BY total_revenue DESC;

--Finding City with Largest Revenue:
SELECT
    city,
    SUM(convert(float,total)) AS total_revenue
FROM [dbo].[WalmartSalesData]
GROUP BY city
ORDER BY total_revenue DESC;


--Finding Product Line with Largest VAT:
SELECT
    [Product line],
    AVG(Convert(float,[Tax 5%])) AS avg_tax
FROM [dbo].[WalmartSalesData]
GROUP BY [Product line]
ORDER BY avg_tax DESC;


--Finding the Good/Bad Product Lines Based on Sales:
SELECT
    [Product line],
    CASE
        WHEN AVG(Convert(float,quantity)) > (SELECT AVG(convert(float,quantity)) FROM [dbo].[WalmartSalesData]) THEN 'Good'
        ELSE 'Bad'
    END AS remark
FROM [dbo].[WalmartSalesData]
GROUP BY [Product line];


--Finding Branch Selling More Than Average:
SELECT
    branch,
    SUM(quantity) AS qnty
FROM [dbo].[WalmartSalesData]
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM [dbo].[WalmartSalesData]);


--Finding Most Common Product Line by Gender:
SELECT
    gender,
    [Product line],
    COUNT(*) AS total_cnt
FROM [dbo].[WalmartSalesData]
GROUP BY gender, [Product line]
ORDER BY total_cnt DESC;


--Finding Average Rating of Each Product Line:
SELECT
    [Product line],
    ROUND(AVG(CONVERT(float,rating)), 2) AS avg_rating
FROM [dbo].[WalmartSalesData]
GROUP BY [Product line]
ORDER BY avg_rating DESC;



--Customer Analysis Queries--

--Finding Unique Customer Types:
SELECT DISTINCT [Customer type] FROM [dbo].[WalmartSalesData];


--Finding Unique Payment Methods:
SELECT DISTINCT payment FROM [dbo].[WalmartSalesData];

--Finding Most Common Customer Type:
SELECT
    [Customer type],
    COUNT(*) AS count
FROM [dbo].[WalmartSalesData]
GROUP BY [Customer type]
ORDER BY count DESC;


--Finding Customer Type Buying the Most:
SELECT
    [Customer type],
    COUNT(*) AS count
FROM [dbo].[WalmartSalesData]
GROUP BY [Customer type]
ORDER BY count DESC;


--Finding Gender of Most Customers:
SELECT
    gender,
    COUNT(*) AS gender_count
FROM [dbo].[WalmartSalesData]
GROUP BY gender
ORDER BY gender_count DESC;

--Finding Gender Distribution per Branch:
SELECT
    branch,
    gender,
    COUNT(*) AS gender_count
FROM [dbo].[WalmartSalesData]
GROUP BY branch, gender
ORDER BY branch, gender_count DESC;


--Sales and Ratings Analysis Queries--

--Finding Time of Day with Most Ratings:
SELECT
    time_of_day,
    AVG(convert(float,rating)) AS avg_rating
FROM [dbo].[WalmartSalesData]
GROUP BY time_of_day
ORDER BY avg_rating DESC;


--Time of Day with Most Ratings per Branch:
SELECT
    branch,
    time_of_day,
    AVG(convert(float,rating)) AS avg_rating
FROM [dbo].[WalmartSalesData]
GROUP BY branch, time_of_day
ORDER BY branch, avg_rating DESC;


--Finding Day of Week with Best Average Ratings:
SELECT
    day_name,
    AVG(convert(float,rating)) AS avg_rating
FROM [dbo].[WalmartSalesData]
GROUP BY day_name
ORDER BY avg_rating DESC;


--Finding Day of Week with Best Average Ratings per Branch:
SELECT
    branch,
    day_name,
    AVG(convert(float,rating)) AS avg_rating
FROM [dbo].[WalmartSalesData]
GROUP BY branch, day_name
ORDER BY branch, avg_rating DESC;


--Additional Sales Analysis Queries--

--Finding Number of Sales by Time of Day per Weekday:
SELECT
    day_name,
    time_of_day,
    COUNT(*) AS total_sales
FROM [dbo].[WalmartSalesData]
GROUP BY day_name, time_of_day
ORDER BY day_name, total_sales DESC;


--Finding Customer Type Bringing the Most Revenue:
SELECT
    [Customer type],
    SUM(Convert(float,total)) AS total_revenue
FROM [dbo].[WalmartSalesData]
GROUP BY [Customer type]
ORDER BY total_revenue DESC;


--Finding City with Largest Tax/VAT Percent:
SELECT
    city,
    ROUND(AVG(Convert(float,[Tax 5%])), 2) AS avg_tax_pct
FROM [dbo].[WalmartSalesData]
GROUP BY city
ORDER BY avg_tax_pct DESC;

--Finding Customer Type Paying the Most in VAT:
SELECT
    [Customer type],
    AVG(Convert(Float,[Tax 5%])) AS avg_tax
FROM [dbo].[WalmartSalesData]
GROUP BY [Customer type]
ORDER BY avg_tax DESC;

