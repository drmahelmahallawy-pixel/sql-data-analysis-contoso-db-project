select c.customerkey 
,concat(c.givenname ,' ' , c.surname ) customername
,c.country  country
,round(SUM(s.quantity*s.netprice),2) total_revenue
,count(distinct s.orderkey ) no_of_orders
,round(sum(s.quantity *s.netprice )/count(distinct s.orderkey ),2) avg_order_value
,min(s.orderdate )  first_purchase
,max(s.orderdate )   last_purchase
,max(s.orderdate ) -min(s.orderdate )  customer_tenure
from customer c 
join sales s 
on c.customerkey = s.customerkey 
where orderdate >= ('2022-01-01')
and orderdate < ('2022-04-01')
group by 1
order by 4 desc 
limit 50
problem 3.3
with base as (select case 
	when s.countryname ilike '%online%' then 'online'
	else 'in_store'
end as channel
,count (distinct o.customerkey ) customer_nomber
,count (o.orderkey ) order_number
,round(sum(s2.quantity *s2.netprice),2) total_rvenue
from orders o 
join store s 
on s.storekey = o.storekey
join sales s2
on s2.orderkey= o.orderkey
where s2.orderdate >= '2022-01-01'
and s2.orderdate <'2022-04-01'
group by 1)
select *,round(a1.total_rvenue /a1.customer_nomber,2)  avg_clv
,round(a1.total_rvenue /a1.order_number,2) avg_order_value
,round(a1.order_number /a1.customer_nomber,4) avg_customer_orders
from base a1
problem3.4
with base as (select c.country 
,c.state 
,count(distinct c.customerkey ) customer_count
,round(sum(s.quantity *s.netprice ),2)  total_reveenue
,round(sum(s.quantity *s.netprice )/count(distinct c.customerkey ),2) avg_per_customer
from sales s 
join customer c 
on s.customerkey = c.customerkey
where s.orderdate >= '2022-01-01'
and s.orderdate <'2022-04-01'
group by 1,2
order by 1,4 desc) ,
base2 as (
select *,sum(a1.total_reveenue ) over () all_revenue
from base a1)
select * ,(round(a2.total_reveenue /a2.all_revenue,4) *100) as rev_percent
from base2 a2