--  Question 1:
--  Write a query to find the top 5 most frequently ordered dishes by the customer "Arjun Mehta" in
--  the last 1 year.
------------------------------------------------------------------

--  join two table 
--- next use (count (*)) to count the each row group by customer_id,customer_name,order_item
--- now calculate the last one year
--- find the top 5 most dishes we use DENSE_RANK()
--- now use cte to get the exact result


select c.customer_id,c.customer_name,o.order_item,count(*) as "total_order",
DENSE_RANK() OVER(order by count(*) desc) as "rank"
from customers c
join orders o on c.customer_id=o.customer_id
where o.order_date>= CURRENT_DATE -INTERVAL '1 year'
and c.customer_name = 'Arjun Mehta'
group by 1,2,3
order by 1,4 desc


--- this is not the exact result as the dense rank is 4 ,so if there is dense rank 5 then we use a cte and 
--- retrieve data with that cte using WHERE rank<=5 to get the frequently order dishes from past one year 
--- BUT IF WE DONT CONSIDER TIME THEN THE TOP 5 DISHES ARE 



WITH food AS
(select c.customer_id,c.customer_name,o.order_item,count(*) as "total_order",
DENSE_RANK() OVER(order by count(*) desc) as "rank"
from customers c
join orders o on c.customer_id=o.customer_id
where c.customer_name = 'Arjun Mehta'
group by 1,2,3
order by 1,4 desc
)
select customer_name,order_item,total_order
from food where rank<=5

-----------------------------**********************-----------------------------------------------
-----------------------------**********************-----------------------------------------------



-- Question 2:
-- Identify the time slots during which the most orders are placed, based on 2-hour intervals.

-- first approach
select 
case

when EXTRACT(HOUR from order_time) between 0 and 1 then '00:00-02:00'
when EXTRACT(HOUR from order_time) between 2 and 3 then '02:00-04:00'
when EXTRACT(HOUR from order_time) between 4 and 5 then '04:00-06:00'
when EXTRACT(HOUR from order_time) between 6 and 7 then '06:00-08:00'
when EXTRACT(HOUR from order_time) between 8 and 9 then '08:00-10:00'
when EXTRACT(HOUR from order_time) between 10 and 11 then '10:00-12:00'
when EXTRACT(HOUR from order_time) between 12 and 13 then '12:00-14:00'
when EXTRACT(HOUR from order_time) between 14 and 15 then '14:00-16:00'
when EXTRACT(HOUR from order_time) between 16 and 17 then '16:00-18:00'
when EXTRACT(HOUR from order_time) between 18 and 19 then '18:00-20:00'
when EXTRACT(HOUR from order_time) between 20 and 21 then '20:00-22:00'
when EXTRACT(HOUR from order_time) between 22 and 23 then '22:00-00:00'

end as time_slot,

count(order_id) as "order_count"

from orders
group by time_slot
order by order_count desc


-- second approach

select 
FLOOR(EXTRACT(HOUR from order_time)/2)*2 as "start_time",
FLOOR(EXTRACT(HOUR from order_time)/2)*2+2 as "end_time",
count(*) as "order_count"
FROM orders
group by 1,2
order by 3 desc


-----------------   ***********  --------------------------------------
-----------------   ***********  --------------------------------------

-- Question 3:
-- order value analysis
-- find the average order value per customer who has placed more than 750 orders
-- return customer name and aov average order value

-- approach
-- join customers and orders table
-- average the total amount of the orders table
-- using a having clause filter the number of order placed 


SELECT c.customer_name, avg(o.total_amount) as aov
FROM orders o
join customers c
on o.customer_id=c.customer_id
GROUP BY 1
having count(o.order_item)>=750;


------------------------  ********  ---------------------------------------
------------------------  ********  ---------------------------------------


-- Question 4:
-- high value customer
-- list the customer who have spent more than 100k in total food orders
-- return customer name, customer id

-- approach 
-- same as the question 3 but insteat of count here we use sum


SELECT c.customer_name, c.customer_id,sum(o.total_amount) as total_spent
FROM orders o
join customers c
on o.customer_id=c.customer_id
GROUP BY 1, 2
having sum(o.total_amount)> 100000
order by 2;

-------------- *******  -----------------------------------------
-------------- *******  -----------------------------------------



-- Question 5. orders without delivery
-- write a query to find orders that were placed but not delivered
-- return each restaurant name, city and number of not delivered orders



-- approach 
-- find where delivery_id is null



select r.restaurant_name,r.city, count(o.order_id) as not_delivered
from orders o
left join restaurants r
on o.restaurant_id=r.restaurant_id
left join deliveries d
on o.order_id=d.order_id
where d.delivery_id is null
group by 1,2
order by 3 desc


------- **** ---------------------------------------
------- **** ---------------------------------------



-- Question 6.
-- restaurant revenue ranking
-- rank restaurants by their total revenue from last year
-- including their name,total revenue,rank within their city

-- approach 
-- use rank function and cte 



with revenue as 
(
	select r.city,r.restaurant_name,sum(o.total_amount) as "Revenue",
    RANK() OVER(PARTITION BY r.city order by (sum(o.total_amount)) desc) as "rank"
    from orders o
    left join restaurants r
    on o.restaurant_id=r.restaurant_id
    where order_date >=current_date - interval '1 year'
    group by 1,2
    order by 1, 3 desc
)
 select * from revenue where rank=1
 
 
 -------------  ******* --------------------------------
 ------------- ********* --------------------------------
 
 
 
 -- Question 7.
 -- most popular dish by city
 -- identify the most popular dish in each city based on the numbers of orders
 
 
 --approach
 -- same as the question 6 but instead of cte we use subquery
 
 
   select * from
 
  ( select r.city,o.order_item, count(o.order_id) as "total_orders",
    RANK() OVER(PARTITION BY r.city order by (count(o.order_id)) desc) as "rank"
    from orders o
    left join restaurants r
    on o.restaurant_id=r.restaurant_id
    group by 1,2
   ) as t1

   where rank=1

 -------- ******* ------------------------------------------------------
 -------- ******* ------------------------------------------------------
 
 
 
 
 -- Question 8.
 -- find the customer who have't placed order in 2024 but in 2023
 
 -- approach 
 -- select customer id who has done order at 2023
 -- select customer id who has not done order at 2024
 
 
select  distinct customer_id
from orders
where extract(year from order_date)=2023
and customer_id not in(
 
	select  distinct customer_id from orders
	where extract(year from order_date)=2024
)
 
 
------------ ******** -----------------------------------------------
------------ ******** -----------------------------------------------


-- Question 9.
-- canelation rate comparison
-- calculate and compare the order cancellation rate for each restaurant
-- between the current year and the previous year

-- approach ,find in 2023 each restaurant done how many  order
-- second step ,use case statement to mark the null delivery_id as 1 ,
-- null delivery_id mean order is not delivered or cancle ,
-- use case inside a count state to count the cancled order
-- all in a cte
--then calculate the cancle ration for 2023 and store dit into another cte 
-- do the same process for the 2024
-- now join two ctes where we store the current and previous year cancle rate
-- cancle ratio =delivered/not_delivered *100





with cancle_ratio_23 as
(
	select o.restaurant_id,
    count(o.order_id) as "delivered",
    count(case when d.delivery_id is null then 1 end) as "not_delivered"
    from orders o
    left join deliveries d
    on o.order_id=d.order_id
    where extract(year from order_date)=2023
    group by 1
 ), last_year as
 
 (
	 select restaurant_id,delivered,not_delivered,
     round(not_delivered::numeric/delivered::numeric *100,2) as "cancle_ratio"
     from cancle_ratio_23
 ),cancle_ratio_24 as
 
 (
	 select o.restaurant_id,
    count(o.order_id) as "delivered",
    count(case when d.delivery_id is null then 1 end) as "not_delivered"
    from orders o
    left join deliveries d
    on o.order_id=d.order_id
    where extract(year from order_date)=2024
    group by 1
 ), current_year as
 
 (
	 select restaurant_id,delivered,not_delivered,
     round(not_delivered::numeric/delivered::numeric *100,2) as "cancle_ratio"
     from cancle_ratio_24
 )
 
 select current_year.restaurant_id as "restaurant_id",
 current_year.cancle_ratio as "current_cs",
 last_year.cancle_ratio as "previus_cs"
 from current_year
 join last_year on current_year.restaurant_id=last_year.restaurant_id
 
 



----------------   ***************** ------------------------------------------------
---------------- ******************** -----------------------------------------------










-- Question 10.
-- monthly restaurant revenue
-- calculate each restaurant growth ratio based on total number of 
-- delivered orders since it joining


-- approache check where delivey id is completed count only those order id 
-- use lag() for getting the previous value
-- growth rate= (current_order-previous_order/previous_order)*100



with growth as
(select o.restaurant_id,
to_char (o.order_date,'mm-yy') as "month",
count(o.order_id) as "current_order",
LAG(count(o.order_id)) OVER(PARTITION BY o.restaurant_id order by to_char (o.order_date,'mm-yy')) as"previous_order"
from orders o
left join deliveries d
on o.order_id=d.order_id
where delivery_status='Delivered'
group by 1, 2
order by 1,2
 )
 
 select restaurant_id ,month,previous_order,current_order,
 round(((current_order::numeric-previous_order::numeric)/previous_order::numeric)*100,2)
 from growth



------------------------- ************ ---------------------------------
------------------------- ************ ---------------------------------








-- Question 11.
-- customer segmentation
-- segment customer 'gold','silver' groups based on their spending 
-- copmared to the average value (aov)  if a customers total spending  exceds the aov 'gold'
-- otherwise 'silver' 
-- write a sql query to determine each segment total number of orders and total revenue


with revenue as
(select customer_id,sum(total_amount) as "spending",
count(order_id) as "total_order",
case
when sum(total_amount)>(select avg(total_amount) from orders) then 'gold'
else 'silver'

end "category"
from orders
group by 1
order by 1

)

select sum(total_order) as "orders",sum(spending) as "tota_revenue",category
from revenue
group by 3

------------------ ****** ------------------
------------------ ****** ------------------


-- Question 12.
-- rider monthly earning
-- calculate each riders total monthly earning,assuring they earn 8% of the order amount


select d.rider_id,
r.rider_name,
to_char (o.order_date,'mm-yy') as "month",
count(d.order_id) as "order_count",
sum (o.total_amount) as "total_order_amount",
round(sum (o.total_amount)::numeric * .08,2) as "earning"
from deliveries d
left join orders o
on d.order_id=o.order_id
left join riders r
on d.rider_id=r.rider_id
group by 1,2,3
order by 1,2




------------ ******* ------------------------------------------
------------*********------------------------------------------




-- Question 13.
-- rider ratin analysis
-- find the number of 5 star,4 star, 3 star rating each rider has
-- rider receive rating based on delivery time
-- if order delivered less than 15 min rider  get 5 star
-- if order delivered between 15 to 20 min they get 4 star
-- delivery after 20 min get 3 star



-- third step
select
rider_id,
star,
count(*) as "total_stars"
from


(--second step 
select 
rider_id,
delivery_took_time,
case
  when  delivery_took_time <15 then '5 star'
  when delivery_took_time between 15 and 20 then '4 star'
  else '3 star'
end as "star"
from


-- first step
(select 
d.rider_id,
o.order_id,
o.order_time,
d.delivery_time,
extract(epoch from (d.delivery_time-o.order_time +
              case when d.delivery_time<o.order_time then interval '1 day'
			  else interval '0 day' 
			  end )) /60 as "delivery_took_time"
from orders o
 join deliveries d
on o.order_id=d.order_id
where delivery_status='Delivered'
 )as  t1
 ) as t2
 group by 1,2
 order by 1,3 desc
 
 



---------------------------- ************ ----------------------------------
----------------------------***************---------------------------------


-- Question 14,
-- order frequency per day
-- analyze order frequency per day of the weak and identify the peak day for each restaurant




with frequency as
(select 
r.restaurant_name,
TO_CHAR(o.order_date, 'day') AS "day",
count(o.order_id) as "total_orders",
RANK() OVER(PARTITION BY r.restaurant_name order by count(o.order_id) desc) as "rank"
from orders o
join restaurants r
on o.restaurant_id=r.restaurant_id
group by 1,2
order by 1,3 desc
 )
 select restaurant_name,day,total_orders from frequency 
 where rank=1





--------------- *********** -----------------------------------------------
--------------- *********** -----------------------------------------------




-- Question 15.
-- customer lifetime value
-- calculate the total revenue generated by each customer overall their orders

select o.customer_id,
c.customer_name,
count(o.order_id) as "order_count",
sum(o.total_amount) as "clv"
from orders o
join customers c
on o.customer_id=c.customer_id
group by 1,2
order by 1



----------------  **********  ------------------------------------------------
---------------- ************* -----------------------------------------------


-- Question 16.
-- Monthly sales trends
-- identify sales trends by comparing each month total sales
-- to the previous month



with tend as
(
	select 
extract(year from order_date) as "year",
extract(month from order_date) as "month",
sum(total_amount) as "total_sale",
LAG(sum(total_amount)) OVER(ORDER BY extract(year from order_date),extract(month from order_date)) as "prev"
from orders
group by 1,2
order by 1,2
 )
 select *,
 round((total_sale::numeric/prev::numeric)*100,2) as "percentage"
 from tend
 
 
 
---------------- ******** ----------------------------------------------
----------------- *********** ------------------------------------------




-- Question 17.
-- order item populrity
-- track the popularity of specific order over tome and identify seasonal deman spikes



select
order_item,
season,
count(order_id) as "total_order"
from
 
(
	select * ,
extract (month from order_date) as "month",
case
 WHEN EXTRACT(month FROM order_date) BETWEEN 3 AND 6 THEN 'Summer'
            WHEN EXTRACT(month FROM order_date) BETWEEN 7 AND 10 THEN 'Monsoon'
            ELSE 'Winter'

end as "season"
from orders
	) as t1
group by 1,2
order by 2,3 desc

