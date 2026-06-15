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