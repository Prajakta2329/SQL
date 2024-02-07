

--1. List the ID, name, and price for all products with a price less than or equal to the average product price.

select product_id ,product_name ,product_price 
from product 
where product_price <= (select avg(product_price) 
                        from product 
                        )
; 
--2. For each product, list its ID and total quantity ordered. Products should be listed in ascending order of the product ID.

select product_id , sum(quantity) as total_quantity_ordered
from order_line  
group by product_id 
order by product_id asc 
;

--3. For each product, list its ID and total quantity ordered. Products should be listed in descending order of total quantity ordered.

select product_id , sum(quantity) as total_quantity_ordered
from order_line  
group by product_id 
order by product_id desc
;

--4. For each product, list its ID, name and total quantity ordered. Products should be listed in ascending order of the product name.

select ol.product_id,p.product_name  , sum(quantity) as total_quantity_ordered 
from order_line ol 
join product p 
on ol.product_id  =  p.product_id 
group by ol.product_id,p.product_name  
order by p.product_name asc
;

--5. List the name for all customers, who have placed 10 or more orders. Each customer name should appear exactly once. 
--Customer names should be sorted in ascending alphabetical order.

-- Assumption: If "orders" refers to the "number of order ids" placed by each
-- customer, the below solution will work fine

select distinct (c.customer_name)
from customer c
join order_header oh on c.customer_id = oh.customer_id
group by c.customer_name
having  COUNT(oh.order_id) >= 10
order by c.customer_name asc;

--Assumption: If "orders" refers to "number of quantity ordered", then the below
--solution will work

select distinct customer_name
from customer c
inner join order_header oh
on oh.customer_id = c.customer_id
inner join order_line ol
on ol.order_id = oh.order_id
where ol.quantity >=10
group by customer_name
order by customer_name; 


--6. Implement the previous query using a subquery and IN adding the requirement that the customers’ orders have been placed after Oct 5, 2020.

select customer_name
from customer
where customer_id in (
select customer_id
from order_header
where order_date > '2020-10-05'
group by customer_id
having count(customer_id) >= 10
order by customer_id
)
order by customer_name;


--7. For each city, list the number of customers from that city, who have placed 3 or more orders. Cities are listed in ascending alphabetical order.

-- Assumption: If "order" refers to the "number of order ids" placed by each
--customer, the below solution will work fine
select c1.city, count(c1.customer_id) 
from (select distinct oh.customer_id, c.city  
	  from customer c 
      join order_header oh 
      on c.customer_id = oh.customer_id 
      group by oh.customer_id, c.city 
      having count(oh.order_id)>=3)c1
group by c1.city 
order by c1.city asc;


--8. Implement the previous using a subquery and IN.


select c.city,count(c.customer_id) as no_of_customers 
from customer c 
where c.customer_id in (select distinct (oh.customer_id) 
						from order_header oh 
						where oh.customer_id is not null 
						group by oh.customer_id 
						having count(oh.order_id)>=3) 
group by c.city 
order by c.city asc;



--9. List the ID for all products, which have NOT been ordered on Dec 5, 2019 or before. Sort your results by the product id in ascending order.  Use EXCEPT for this query.

select product_id
from product p 
except
select distinct ol.product_id
from order_line ol 
inner join order_header oh 
on ol.order_id = oh.order_id 
where oh.order_date  <= '2019-12-05'
order by product_id asc;


--10. List the ID for all California customers, who have placed one or more orders on Dec 5, 2019 or after. Sort the results by the customer id in ascending order.  
--Use Intersect for this query.  Make sure to look for alternate spellings for Calfornia, like "CA"
select c.customer_id 
from customer c 
where c.state_province  in ('California','CA')
intersect
select  oh.customer_id 
from order_header oh 
where oh.order_date >='2019-12-05'
group by oh.customer_id 
having count(oh.order_id)>=1
order by customer_id asc;

--11. Implement the previous query using a subquery and IN.

select c.customer_id 
from customer c 
where lower(c.state_province)  in ('california','ca') 
and c.customer_id in (select distinct oh.customer_id 
					 from order_header oh 
					 where oh.order_date >='2019-12-05' 
                     group by oh.customer_id 
                     having count(oh.order_id)>=1) 
order by c.customer_id asc;


--12. List the IDs for all California customers along with all customers (regardless where they are from) who have placed one or more order(s) before Nov 5, 2020. 
--Sort the results by the customer id in ascending order.  Use union for this query.

select c.customer_id 
from customer c 
where lower(c.state_province)  in ('california','ca')
union
select oh.customer_id 
from order_header oh 
where oh.order_date <='2020-11-05' 
group by oh.customer_id 
having count(oh.order_id)>=1 
order by customer_id asc;


--13. List the product ID, product name and total quantity ordered for all products with total quantity ordered greater than 5.

select  p.product_id, p.product_name, sum(ol.quantity) as total_quantity 
from order_line ol 
inner join product p 
on ol.product_id = p.product_id 
group by p.product_id  
having sum(ol.quantity)>5 ;

-- 14. List the product ID, product name  and total quantity ordered for all products with total quantity ordered greater than 3 and were placed by Nevada customers.  Make sure to look for alternative spellings for Nevada state, such as "NV".

select  p.product_id, p.product_name, sum(ol.quantity) as total_quantity 
from customer c 
inner join order_header oh 
on c.customer_id = oh.customer_id 
inner join order_line ol 
on oh.order_id = ol.order_id 
inner join product p 
on ol.product_id = p.product_id 
where lower(c.state_province) in ('nevada','nv') 
group by p.product_id  
having sum(ol.quantity)>3;













