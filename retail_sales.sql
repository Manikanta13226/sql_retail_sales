create database retail_sales_p1;
use retail_sales_p1;

select * from retail_sales;


select * from retail_sales
limit 10;


SELECT COUNT(*)
FROM retail_sales;

SELECT *
FROM retail_sales
WHERE sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantiy IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
 
 -- Data Exploration
 
 select count(*) as total_sales from retail_sales;
 
 select count(distinct customer_id) as total_sales from retail_sales;
 
 select distinct category from retail_sales;
 
 -- Data analysis & Business key problem & answers
 -- Q.1 Write a SQl query to retrive all columns for sales made on '2022-11-05'?
 select * from retail_sales
 where sale_date='2022-11-05';
 
 -- Q.2 write a sql query to retrive all transactions where the category is 'clothing' and the quantity sold more than 4 in the month of Nov-2022?
 select * from retail_sales
 where 
	category='Clothing'
    and 
    date_format(sale_date,'%y-%m')='2022-11'
    and 
    quantity >=4;
    
-- Q.3 write a SQL query to calculate the total sales (total_sale) for each category?
select 
	category,
    sum(total_sale) as net_sale,
    count(*) as total_orders
from retail_sales
group by category;

-- Q.4 write a sql query to find the average age of customer who purchased items from the 'Beauty' category?
select 
	round(avg(age),2) as avg_age
from retail_sales
where category='Beauty';

-- Q.5 write a sql query to find all transactions where the totak_sale is greater than 1000?
select * from retail_sales
where total_sale>1000;

-- Q.6 write a sql query to find the total number of transactions (transaction_id) made by each gender in each category?
select 
	category,
    gender,
    count(*) as total_trans
from retail_sales
group by category,
		gender
order by 1;

-- Q.7 write a sql query to calculate the average sale of each month. find out best selling month in each year?
select 
	year,
    month,
    avg_sale
from
(
	select
		extract(year from sale_date) as year,
        extract(month from sale_date) as month,
        avg(total_sale) as avg_sale,
        rank() over(
				partition by extract(year from sale_date) 
                order by avg(total_sale) DESC
                ) as rnk
	from retail_sales
    group by year, month
) as t1
where rnk=1;

-- Q.8 write Sql query to find the top 5 customers based on the heighest total sales?
select 
	customer_id,
    sum(total_sale) as total_sales
from retail_sales
group by customer_id
order by total_sales desc
limit 05;

-- Q.9 Write a sql query to find the number of unique customers who purchase items from each category?
select
	category,
    count(distinct customer_id) as cnt_unique_cs
from retail_sales
group by category;

-- Q.10 write a sql query to create each shift and number of orders (example: morning <12, afternoon between 12 and 17, evening >17)

with hourly_sale
as
(
select *,
	case
		when extract(hour from sale_time) <12 then 'Morning'
        when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
        else 'Evening'
	end as shift
from retail_sales
)
select 
	shift,
    count(*) as total_orders
from hourly_sale
group by shift;
    
    