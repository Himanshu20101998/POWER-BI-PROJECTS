use pizza_project;
select * from pizza_sales;
-- i want to know the total revenue generated
select sum(total_price) as net_revenue_generated from pizza_sales;
-- now i want to know the avg order value, which can be calculated by dividing the total revenue by the total no. of distinct orders.
select sum(total_price)/count(distinct order_id) as avg_order_value from pizza_sales;
-- now i want to know the amount of total pizzas sold.
select sum(quantity) as total_pizza_sold from pizza_sales;
-- Now I want to know the total orders placed.
select count(distinct(order_id)) as total_orders_placed from pizza_sales;
-- Now I want to know the avg amount of pizzas per order.
select sum(quantity)/count(distinct(order_id)) as avg_pizza_per_order from pizza_sales;
-- now I want to know the daily trend for total orders.
set sql_safe_updates=0;

describe pizza_sales;

UPDATE pizza_sales
SET order_date = REPLACE(order_date, '-', '/');


ALTER TABLE pizza_sales ADD new_order_date DATE;

-- Step 2: Update the new column
UPDATE pizza_sales
SET new_order_date = STR_TO_DATE(order_date, '%d/%m/%Y');

-- Step 3: Verify data

-- Step 4: Drop the original column (optional)
ALTER TABLE pizza_sales DROP COLUMN order_date;

-- Step 5: Rename the new column (optional)
ALTER TABLE pizza_sales CHANGE new_order_date order_date DATE;
-- now this below query is giving me weekdays name in random format
select dayname(order_date) as order_day, count(distinct order_id) as total_orders from pizza_sales group by dayname(order_date) order by order_day;
-- ***now this below query will help me to get the weekdays name in proper sequence wise.
SELECT 
    weekday_names.order_day,
    IFNULL(agg_data.total_orders, 0) AS total_orders
FROM (
    SELECT 'Sunday' AS order_day, 1 AS day_order
    UNION ALL SELECT 'Monday', 2
    UNION ALL SELECT 'Tuesday', 3
    UNION ALL SELECT 'Wednesday', 4
    UNION ALL SELECT 'Thursday', 5
    UNION ALL SELECT 'Friday', 6
    UNION ALL SELECT 'Saturday', 7
) AS weekday_names
LEFT JOIN (
    SELECT
    DAYNAME(order_date) AS order_day,
        DAYOFWEEK(order_date) AS day_order,
        COUNT(DISTINCT order_id) AS total_orders
    FROM pizza_sales
    GROUP BY order_day, day_order
) AS agg_data ON weekday_names.order_day = agg_data.order_day
ORDER BY weekday_names.day_order;

-- now I want to know the monthly trend for total orders.
select monthname(order_date) as month_order, count(distinct order_id) as total_orders from pizza_sales group by monthname(order_date) order by total_orders desc;
-- now I want to know the percentage of sales by pizza category.
select count(distinct pizza_category) from pizza_sales;
select sum(total_price) as total_revenue_category_wise, pizza_category  from pizza_sales 
group by pizza_category order by total_revenue_category_wise desc;
select pizza_category, sum(total_price)*100/(select sum(total_price) from pizza_sales) as 
pizza_category_percentage_sales from pizza_sales group by pizza_category order by pizza_category_percentage_sales desc;
-- now if I want to know the percentage of sales by pizza category only for OCTOBER month.
select pizza_category, sum(total_price)*100/(select sum(total_price) from pizza_sales where month(order_date)=10 ) as 
pizza_category_percentage_sales from pizza_sales where month(order_date)=10 group by 
pizza_category order by pizza_category_percentage_sales desc;

-- now i want to know the precentage of sales by pizza size.
select pizza_size,sum(total_price)*100/(select sum(total_price) from pizza_sales) as pizza_size_percentage_sales from 
pizza_sales group by pizza_size order by pizza_size_percentage_sales desc;
       
-- now i want to know the precentage of sales by pizza size only for 1st quarter.       
select pizza_size,sum(total_price)*100/(select sum(total_price) from pizza_sales where quarter(order_date)=1 ) as pizza_size_percentage_sales from 
pizza_sales where quarter(order_date)=1 group by pizza_size order by pizza_size_percentage_sales desc;

-- Now I want to know the top 5 and bottom 5 best and worst selling pizzas based on the revenue generated.
select  pizza_name, sum(total_price) as total_sales_by_pizza_name from pizza_sales group by pizza_name order by 
total_sales_by_pizza_name desc limit 5 ;

select  pizza_name, sum(total_price) as total_sales_by_pizza_name from pizza_sales group by pizza_name order by 
total_sales_by_pizza_name asc limit 5 ;
-- Now I want to know the top 5 and bottom 5 best and worst selling pizzas based on the quantity ordered.
select pizza_name, sum(quantity) as total_quantity_ordered from pizza_sales group by pizza_name order by total_quantity_ordered desc limit 5;
select pizza_name, sum(quantity) as total_quantity_ordered from pizza_sales group by pizza_name order by total_quantity_ordered asc limit 5;

-- Now I want to know the top 5 and bottom 5 best and worst selling pizzas based on the  ordered frequency.
select pizza_name, count(distinct order_id) as total_orders_placed from pizza_sales 
group by pizza_name order by total_orders_placed desc limit 5;
select pizza_name, count(distinct order_id) as total_orders_placed from pizza_sales 
group by pizza_name order by total_orders_placed asc limit 5;


