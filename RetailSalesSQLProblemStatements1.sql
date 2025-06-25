-- Any null values in transactions_id column
select * from retail_sales where transactions_id is null;

-- Any null values in sale_date column
select * from retail_sales where sale_date is null;

-- Checking null values in every column using or 
select * from retail_sales where 
sale_time is null 
or customer_id is null
or gender is null
or age is null
or category  is null
or quantiy  is null
or price_per_unit  is null
or cogs  is null
or total_sale  is null;

-- DATA EXPLORATION
-- How many sales we have?
select count(*) as Total_Sales_Transactions from retail_sales;

-- How many unique customers we have?
select count(distinct customer_id) as Total_Customers from retail_sales;

-- What are the unique categories we have?
select distinct category as Categories from retail_sales;

-- BUSINESS PROBLEMS

-- 1. Retrieve all columns for sales made on '2022-11-05'
SELECT count(*) FROM retail_sales where sale_date='2022-11-05';

-- 2. Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov 2022
SELECT 
    COUNT(*) as TransactionsCount
FROM
    retail_sales
WHERE
    category = 'Clothing' AND quantiy > 3
        AND sale_date LIKE '%-11-%';

-- 3. calculate the total sales  (total_sale) for each category
SELECT category, sum(total_sale) as TotalSale, count(*) as Total_Sales FROM retail_sales group by category;

-- 4. Find the average age of customer who purchased items from the 'beauty' category
select  round(avg(age), 2) as 'Avg Age of Customer' from retail_sales where category= 'Beauty';

-- 5. Find all the transactions where the total_sale is greater than 1000.
SELECT count(*) as 'Tota_Sale>1000' FROM retail_sales where total_sale > 1000;

-- 6. Find the total no of transactions made by gender in each category
SELECT category, gender, count(transactions_id) as TransactionsCount FROM retail_sales group by gender, category;

-- 7. Calculate the avg sales in each month. Find best selling month in each year
-- Avg sales in each month
SELECT 
    YEAR(sale_date) AS YearName,
    MONTHNAME(sale_date) AS MonthName,
    round(avg(total_sale),2) AS Sales_Count
FROM
    retail_sales
    group by 1,2
    order by 1,2;
    
-- best selling month in each year
select * from
(select YEAR(sale_date) AS YearName,
    MONTHNAME(sale_date) AS MonthName,
    round(avg(total_sale),2) as Avg_Sales,
    rank() over(partition by YEAR(sale_date) order by avg(total_sale) desc) as Ranks
    from retail_sales
    group by 1,2 ) as t1 
    where Ranks =1;

-- Best Months based on sales count
SELECT 
    YEAR(sale_date) AS YearName,
    MONTHNAME(sale_date) AS MonthName,
    COUNT(*) AS Sales_Count
FROM
    retail_sales
GROUP BY MonthName , YearName
ORDER BY Sales_Count DESC ;

-- Best Month based on sales count
SELECT 
    YEAR(sale_date) AS YearName,
    MONTHNAME(sale_date) AS MonthName,
    COUNT(*) AS Sales_Count
FROM
    retail_sales
GROUP BY MonthName , YearName
ORDER BY Sales_Count DESC limit 1;

-- Best Months based on total sales
SELECT 
    YEAR(sale_date) AS YearName,
    MONTHNAME(sale_date) AS MonthName,
    sum(total_sale) AS Sales_Count
FROM
    retail_sales
GROUP BY MonthName , YearName
ORDER BY Sales_Count DESC;

-- Best Month based on total sales
SELECT 
    YEAR(sale_date) AS YearName,
    MONTHNAME(sale_date) AS MonthName,
    sum(total_sale) AS Sales_Count
FROM
    retail_sales
GROUP BY MonthName , YearName
ORDER BY Sales_Count DESC limit 1;

-- 8. Find the top 5 customers based on the highest total sales
select customer_id, sum(total_sale) as Sales_Sum from retail_sales group by customer_id order by Sales_Sum desc limit 5 ; 

-- 9. Find the no. of unique customers who purchased items from each customer
select distinct category, count( distinct customer_id) as distinct_Customer  from retail_sales group by category;

-- 10. Create each shift and no. of orders(Morning <= 12, Afternoon Betweeen 12 & 17, Evening > 17)

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




