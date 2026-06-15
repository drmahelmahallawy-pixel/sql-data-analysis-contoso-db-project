problem 7.1
with base as (select
p.categoryname 
, p.productkey  
,p.productname 
,d.monthnumber 
,round(sum(s.quantity * s.netprice),2) revenue
from sales s 
join product p 
on s.productkey = p.productkey 
and s.orderdate >= '2025-01-01'
join "date" d 
on d."date" =s.orderdate 
group by 1,2,3,4),
base2 as (
select *,rank() over (partition by a1.categoryname,a1.monthnumber  order by a1.revenue desc ) as product_rank
from base a1)
select *
from base2 a2
where a2.product_rank <=10
problem 7.2
with base as (
select d."date" 
,round(sum(s.quantity * s.netprice),2) revenue
from sales s
join date d 
on d."date" = s.orderdate 
and s.orderdate >= '2025-01-01'
group by 1)
select *
,round(avg(a1.revenue )over (order by a1."date" rows between 6 preceding and current row ),2) as a7_day_avg
,round(avg(a1.revenue )over (order by a1."date" rows between 29 preceding and current row ),2) as a30_days_avg
from base a1
problem 7.3
with base as (select s.productkey 
,p.productname 
,round(sum(s.quantity * s.netprice),2) revenue
from sales s
join product p 
on p.productkey = s.productkey 
and  s.orderdate >= '2025-01-01'
group by 1,2
)
select *
,ntile(4) over (order by a1.revenue desc) quartile
,percent_rank () over (order by a1.revenue  )*100 percentile
from base a1 
order by a1.revenue desc 
problem 7.4
with base as (select c.customerkey 
,c.givenname 
,round(sum(s.quantity * s.netprice),2) revenue
from sales s 
join customer c 
on s.customerkey = c.customerkey
and  s.orderdate >= '2025-01-01'
group by 1,2
order by 3 desc),
base2 as (
select *
,sum(a1.revenue ) over (order by a1.revenue desc) as running_total
,sum(a1.revenue ) over () as total
from base a1
),
base3 as(
select *
,round(a2.running_total /a2.total *100,2) cum_percent
from base2 a2)
select *
from base3 a3 
where a3.cum_percent <= 80