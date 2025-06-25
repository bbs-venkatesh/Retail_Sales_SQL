-- 🔹 Sales & Revenue Analysis

-- 1️. What is the total revenue generated overall and per product category?
-- Total Revenue
select sum(total_sale) as TotalRevenue from retail_sales;

-- Overall Sales based on product category
select category, sum(total_sale) as CategoryWiseRevenue from retail_sales group by category;

-- 2️. Which category has the highest average order value?
select category, round(avg(total_sale),2) as HighestAvgRevenue from retail_sales group by category order by HighestAvgRevenue desc limit 1;

-- 3️. What is the trend of monthly sales? (group by month/year)

SELECT 
    MONTHNAME(sale_date) AS Months,
    YEAR(sale_date) AS Years,
    SUM(total_sale) AS Revenue,
    rank() over(partition by monthname(sale_date) order by sum(total_sale) desc) as Ranks
FROM
    retail_sales
GROUP BY Months , Years
ORDER BY Revenue DESC;

-- 4️. Who are the top 5 customers by total sales?
select customer_id, sum(total_sale) as Total from retail_sales group by customer_id order by Total desc limit 5;

--  Customer & Demographics Insights
-- 5️. What is the average spend by male vs female customers?
select gender, round(avg(total_sale),2) as Avg_Spent from retail_sales group by gender;

-- 6️. How does spending vary across age groups (e.g., 18–25, 26–35, etc.)?
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
 
-- 🔹 Operational Metrics

-- 7️. Which hour of the day has the highest sales? (using sale_time)
select hour(sale_time) as HouroftheDay, sum(total_sale) as Revenue from retail_sales group by HouroftheDay order by Revenue desc;

-- 8️. What is the total quantity sold per category?
select category, sum(quantiy) as Total_Quantity from retail_sales group by category;

-- 🔹 Advanced SQL Ideas
-- 9. Identify repeat customers — how many customers made more than 1 purchase?
SELECT 
    customer_id, COUNT(transactions_id) AS Purchase_Count
FROM
    retail_sales
GROUP BY customer_id
HAVING Purchase_Count > 1
ORDER BY Purchase_Count DESC;

-- 10. Rank categories by total sales within each month (window function + partition by month).
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


