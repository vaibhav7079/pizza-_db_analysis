create database pizza;
use pizza;
select * from orders;

--Retrieve the total number of orders placed.

select count(*) as numer_of_orders from orders;

--Calculate the total revenue generated from pizza sales.

select sum(quantity * price) as revenue from pizzas p join order_details od on
p.pizza_id = od.pizza_id;

--Identify the highest-priced pizza.
select top 1 pizza_id,pizza_type_id,max(price) as max_price from pizzas
group by pizza_id,pizza_type_id
order by max(price) desc;

--Identify the most common pizza size ordered.
select top 1 size , count(size) as no_of_orders from  pizzas p join order_details od on
p.pizza_id = od.pizza_id
group by size
order by count(size) desc;

--List the top 5 most ordered pizza types along with their quantities.
select top 5 p.pizza_id , sum(quantity) as quantity_ordered from pizzas p join order_details od on
p.pizza_id = od.pizza_id
group by p.pizza_id
order by sum(quantity) desc;

--Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_type_id , count(pizza_type_id) as nu_of_pizza from  pizzas p join order_details od on
p.pizza_id = od.pizza_id
group by pizza_type_id
order by count(pizza_type_id);

--Determine the distribution of orders by hour of the day.

select  datepart(hour,[time]) as [hour], count(order_id) as no_of_orders from orders
group by datepart(hour,[time]) 
order by count(order_id) desc;

--Group the orders by date and calculate the average number of pizzas ordered per day.
select avg([sum])  as avg_pizza_per_day from
(select [date] , sum(quantity) as [sum] from orders o join order_details od on
o.order_id = od.order_id
group by [date]) as x;

--Determine the top 3 most ordered pizza types based on revenue.
select  top 3 pizza_type_id,sum(quantity * price) as revenue from pizzas p join order_details od on
p.pizza_id = od.pizza_id
group by pizza_type_id
order by revenue desc;

--Calculate the percentage contribution of each pizza type to total revenue.


select  top 3 pizza_type_id,(sum(quantity * price)/(select sum(quantity * price) as revenue from pizzas p join order_details od on
p.pizza_id = od.pizza_id) *100) as revenue from pizzas p join order_details od on
p.pizza_id = od.pizza_id
group by pizza_type_id
order by revenue desc;

--Analyze the cumulative revenue generated over time.
select [date],sum(revenue) over(order by [date]) as cum_rev from
(select [date], sum(quantity * price) as revenue from pizzas p join order_details od on
p.pizza_id = od.pizza_id join orders o on
od.order_id = o.order_id
group by [date])as x;

--Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select * from orders;
select * from order_details;
select  * from pizzas  ;

select pizza_id , pizza_type_id , revenue , ranks from
(select pizza_id , pizza_type_id , revenue, rank() over(partition by pizza_type_id order by revenue desc) as ranks from
(select p.pizza_id,pizza_type_id, sum(quantity * price) as revenue from pizzas p join order_details od on
p.pizza_id = od.pizza_id join orders o on
od.order_id = o.order_id
group by pizza_type_id , p.pizza_id) as cv) as x where ranks <=3;


select case 
when p.pizza_id like '%chk%' then 'chicken'
when p.pizza_id like '%veg%' then 'veg'
when p.pizza_id like '%classic%' then 'classic' 
else 'other' end as category
, p.pizza_id,pizza_type_id, sum(quantity * price) as revenue from pizzas p join order_details od on
p.pizza_id = od.pizza_id join orders o on
od.order_id = o.order_id
group by pizza_type_id , p.pizza_id;

