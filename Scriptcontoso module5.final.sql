--with base as (select p.productname 
--,p.categoryname 
--,SUM(s.quantity) sold_quantity
--,sum(s.quantity*s.netprice) revenue
--from product p 
--left join sales s
--on p.productkey = s.productkey
--and s.orderdate >= '2022-01-01'
--and s.orderdate < '2023-01-01'
--group by 1,2
--order by 3,4)
--select *,
--case 
--	when a1.sold_quantity <200 then 'low sales'
--	when a1.revenue < 5000 then 'low sales'
--	else 'active'
--end as sales_type
--from base a1
------problem 5.2
--select count(*)
--from orders o 
--left join sales s 
--on s.orderkey= o.orderkey
--where s.orderkey is null
--and s.orderdate >= '2025-09-01'
--union all 
--select count(*)
--from sales s 
--left join orders o 
--on o.orderkey = s.orderkey
--and s.orderdate >= '2025-09-01'
--where o.orderkey is null
-----problem 5.3
--select s.currencycode 
--,round(sum(s.quantity*s.netprice ),2) orig_revenue
--, COUNT(s.orderkey )
--,round (sum(s.quantity *s.netprice*c.exchange  ),2) usd_revenue
--from sales s
--join currencyexchange c 
--on s.currencycode = c.fromcurrency  and s.orderdate = c."date" 
--where c.tocurrency ='USD'
--and s.orderdate >= '2025-09-01'
--group by 1
--problem 5.4
select s2.countryname 
,s2.state 
,round(sum(s.quantity * s.netprice ),2) revenue
,count (s.customerkey )  customer_count
from sales s
join store s2 
on s.storekey =s2.storekey 
join customer c 
on s.customerkey =c.customerkey and c.state like s2.state 
group by 1,2