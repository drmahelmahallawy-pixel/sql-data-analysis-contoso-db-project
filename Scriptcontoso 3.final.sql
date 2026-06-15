with base as (
select 
s.customerkey 
,d.yearmonthnumber 
,d.yearmonthshort 
,count(s.orderkey ) orders
from sales s 
join "date" d 
on date_trunc('day',s.orderdate )= d."date" 
where d."year" in ('2023','2024')
group by 1,2,3
)
select 
a1.yearmonthnumber 
,a1.yearmonthshort  
,a2.yearmonthnumber 
,a2.yearmonthshort 
,count(distinct a2.customerkey ) as guests
from base a1
left join base a2 on a1.customerkey =a2.customerkey 
where a2.yearmonthnumber >= a1.yearmonthnumber 
group by 
a1.yearmonthnumber 
,a1.yearmonthshort  
,a2.yearmonthnumber 
,a2.yearmonthshort 
----------------------------------------problem 7.4
with base as (select c.customerkey 
,concat(c.givenname ,' ',c.surname)
,sum(s.netprice *s.quantity ) revenue
,sum(sum(s.netprice *s.quantity  ) )over () total_revenue
from customer c 
inner join sales s
on s.customerkey= c.customerkey 
where s.orderdate >= '2022-01-01' and s.orderdate <'2024-01-01'
group by 1,2
),
 base2 as (
select *,round(a1.revenue /a1.total_revenue*100,5)  rev_cont_percent
from base a1),
final as (
select *
,sum (a2.rev_cont_percent) over (order by a2.revenue  desc ) cum_rev_perc
from base2 a2
),
pareto as (
select count (*)  as top_customers
,(select count (*) from base ) as total_customers
,round(count(*) /cast ((select count(*) from base ) as numeric)  *100,2) as pct_of_totalexcept 
from final f
where f.cum_rev_perc <=80)
select *
from pareto 