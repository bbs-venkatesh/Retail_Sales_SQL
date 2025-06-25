# Retail Sales SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `p1_retail_db`


This project showcases SQL skills applied to a sample retail sales dataset. It answers key business questions using SQL queries involving aggregation, grouping, window functions, and CTEs. The project is designed as part of my data analyst portfolio.

## 📊 Business Questions Answered
- Write a SQL query to retrieve all columns for sales made on '2022-11-05
- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
- Write a SQL query to calculate the total sales (total_sale) for each category.
- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
- Write a SQL query to find all transactions where the total sale is greater than 1000.
- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
- Write a SQL query to calculate the average sale for each month. Find out best best-selling month in each year
- Write a SQL query to find the top 5 customers based on the highest total sales 
- Write a SQL query to find the number of unique customers who purchased items from each category.
- Write a SQL query to create each shift and number of orders (Example: Morning <12, Afternoon Between 12 & 17, Evening >17)
- What is the total revenue generated overall and per product category?
- Which category has the highest average order value?
- What is the trend of monthly sales?
- Who are the top 5 customers by total sales?
- How does spending vary across genders and age groups?
- What hours of the day have the highest sales?
- Which categories are ranked highest by monthly sales?
- Who are repeat customers?

## 🛠 SQL Concepts Used
- Aggregation (`SUM`, `AVG`, `COUNT`)
- Grouping and ordering
- Window functions (`RANK`, `DENSE_RANK`)
- CTEs (Common Table Expressions)
- Date and time functions
  
# Insights Summary

- 📌 **Total Revenue:** ₹ 9,07,330
- 📌 **Total Sales Transactions:** 1986
- 📌 **Total Unique Customers:** 155
- 📌 **Total Categories:** Beauty, Clothing, Electronics
- 📌 **Top Category by Revenue:** Electronics
- 📌 **Top Category by Average Order Value:** Beauty
- 📌 **Month with Highest Sales:** December 2022 (₹ 71,880)
- 📌 **Top Customer:** Customer ID 3 (₹ 38,440)
- 📌 **Most Sales Time:** 7 PM

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT count(*) FROM retail_sales where sale_date='2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT 
    COUNT(*) as TransactionsCount
FROM
    retail_sales
WHERE
    category = 'Clothing' AND quantiy > 3
        AND sale_date LIKE '%-11-%';
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT category, sum(total_sale) as TotalSale, count(*) as Total_Sales FROM retail_sales group by category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
select  round(avg(age), 2) as 'Avg Age of Customer' from retail_sales where category= 'Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT count(*) as 'Tota_Sale>1000' FROM retail_sales where total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT category, gender, count(transactions_id) as TransactionsCount FROM retail_sales group by gender, category;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
**-- Avg sales in each month**
```sql   
SELECT 
    YEAR(sale_date) AS YearName,
    MONTHNAME(sale_date) AS MonthName,
    ROUND(AVG(total_sale), 2) AS Sales_Count
FROM
    retail_sales
GROUP BY 1 , 2
ORDER BY 1 , 2;
```
    
**-- best-selling month in each year**
```sql
select * from
(select YEAR(sale_date) AS YearName,
    MONTHNAME(sale_date) AS MonthName,
    round(avg(total_sale),2) as Avg_Sales,
    rank() over(partition by YEAR(sale_date) order by avg(total_sale) desc) as Ranks
    from retail_sales
    group by 1,2 ) as t1 
    where Ranks =1;
```

**-- Best Months based on sales count**
```sql
SELECT 
    YEAR(sale_date) AS YearName,
    MONTHNAME(sale_date) AS MonthName,
    COUNT(*) AS Sales_Count
FROM
    retail_sales
GROUP BY MonthName , YearName
ORDER BY Sales_Count DESC ;
```

**-- Best Month based on sales count**
```sql
SELECT 
    YEAR(sale_date) AS YearName,
    MONTHNAME(sale_date) AS MonthName,
    COUNT(*) AS Sales_Count
FROM
    retail_sales
GROUP BY MonthName , YearName
ORDER BY Sales_Count DESC limit 1;
```

**-- Best Months based on total sales**
```sql
SELECT 
    YEAR(sale_date) AS YearName,
    MONTHNAME(sale_date) AS MonthName,
    sum(total_sale) AS Sales_Count
FROM
    retail_sales
GROUP BY MonthName , YearName
ORDER BY Sales_Count DESC;
```

**-- Best Month based on total sales**
```sql
SELECT 
    YEAR(sale_date) AS YearName,
    MONTHNAME(sale_date) AS MonthName,
    sum(total_sale) AS Sales_Count
FROM
    retail_sales
GROUP BY MonthName , YearName
ORDER BY Sales_Count DESC limit 1;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
select customer_id, sum(total_sale) as Sales_Sum from retail_sales group by customer_id order by Sales_Sum desc limit 5 ;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
select distinct category, count( distinct customer_id) as distinct_Customer  from retail_sales group by category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
with hourly_shift as(
select *,
case
when hour(sale_time) < 12 then 'Morning'
when hour(sale_time) >12 and hour(sale_time) < 17 then 'Afternoon'
else 'Evening'
end shift
 from retail_sales)
 select shift, count(*) order_Count from hourly_shift 
 group by shift;
```

11. **What is the total revenue generated overall and per product category?**
**Total Revenue**
```sql
select sum(total_sale) as TotalRevenue from retail_sales;
```

 **Overall Sales based on product category**
```sql
select category, sum(total_sale) as CategoryWiseRevenue from retail_sales group by category;
```

12. **Which category has the highest average order value?**
```sql
select category, round(avg(total_sale),2) as HighestAvgRevenue from retail_sales group by category order by HighestAvgRevenue desc limit 1;
```

13. **What is the trend of monthly sales?**
```sql
SELECT 
    MONTHNAME(sale_date) AS Months,
    YEAR(sale_date) AS Years,
    SUM(total_sale) AS Revenue,
    rank() over(partition by monthname(sale_date) order by sum(total_sale) desc) as Ranks
FROM
    retail_sales
GROUP BY Months , Years
ORDER BY Revenue DESC;
```

14. **Who are the top 5 customers by total sales?**
```sql
select customer_id, sum(total_sale) as Total from retail_sales group by customer_id order by Total desc limit 5;
```

15. **What is the average spend by male vs female customers?**
```sql
select gender, round(avg(total_sale),2) as Avg_Spent from retail_sales group by gender;
```

16. **How does spending vary across age groups?**
```sql
with ag_group as
(select *,
case
when age>=18 and age<25 then '18 - 25'
when age>=25 and age<35 then '25 - 35'
when age>=35 and age<45 then '35 - 45'
when age>=45 and age<55 then '45 - 55'
else '55 - 65'
end age_group
 from retail_sales)
 select age_group, sum(total_sale) from ag_group group by age_group;
```

17. **Which hour of the day has the highest sales?**
```sql
select hour(sale_time) as HouroftheDay, sum(total_sale) as Revenue from retail_sales group by HouroftheDay order by Revenue desc;
```

18. **What is the total quantity sold per category?**
```sql
select category, sum(quantiy) as Total_Quantity from retail_sales group by category;
```

19. **Identify repeat customers — how many customers made more than 1 purchase?**
```sql
SELECT 
    customer_id, COUNT(transactions_id) AS Purchase_Count
FROM
    retail_sales
GROUP BY customer_id
HAVING Purchase_Count > 1
ORDER BY Purchase_Count DESC;
```

20. **Rank categories by total sales within each month (window function + partition by month).**
```sql
SELECT 
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    category,
    SUM(total_sale) AS monthly_category_sales,
    RANK() OVER (
        PARTITION BY YEAR(sale_date), MONTH(sale_date)
        ORDER BY SUM(total_sale) DESC
    ) AS category_rank
FROM 
    retail_sales
GROUP BY 
    YEAR(sale_date), 
    MONTH(sale_date), 
    category
ORDER BY 
    year, 
    month, 
    category_rank;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## Author - BB Siva Venkatesh

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/siva-venkatesh/)


Thank you for your support, and I look forward to connecting with you!
