problem 6.1
with base as (
select p.productkey
,p.productname
,round(sum(s.quantity*s.netprice),2) revenue
from product p 
join sales s 
on p.productkey = s.productkey 
group by 1,2),
base2 as(
select *,round(AVG(a1.revenue ) over (),2) as avg_revenue
from base a1),
base3 as (
select *
from base2 a2
where a2.revenue > a2.avg_revenue )
select*,round((a3.revenue -a3.avg_revenue ),2) above_avg_amount
,round((a3.revenue -a3.avg_revenue )/a3.avg_revenue *100 ,2) pct
from base3 a3
problem 6.2
with base as(
select c.country 
,c.customerkey 
,c.givenname 
,round(sum(s.quantity *s.netprice ),2) revenue
from sales s 
join customer c 
on s.customerkey = c.customerkey
and s.orderdate >='2025-01-01'
group by 1,2,3
),
base2 as (select *
,rank() over(partition by a1.country order by a1.revenue desc ) as country_top_customer
from base a1)
select *
from base2 a2
where a2.country_top_customer <=3
problem 6.3
with base as (select d."year" 
,d.monthnumber ,
d.monthshort 
,round(sum(s.quantity*s.netprice ),2) revenue
from sales s
join "date" d 
on d."date" = s.orderdate 
group by 1,2,3),
base2 as (
select *,lag(a1.revenue ) over(partition by a1."year"  order by  a1.monthnumber ) last_month_revenue
from base a1),
base3 as(
select*
,round((a2.revenue - a2.last_month_revenue) /a2.last_month_revenue *100 ,2) growth
from base2 a2 )
select *
from base3 a3
where a3.growth >= 10
order by  a3."year" ,a3.monthnumber
problem 6.4
cohort analysis done