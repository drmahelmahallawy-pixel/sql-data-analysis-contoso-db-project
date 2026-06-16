with base as (select s.customerkey ,concat(c.givenname , ' ',c.surname )as customer_name ,
count(s.orderkey ) as order_number,
max(s.orderdate )  last_purchase
from sales s
join customer c 
on c.customerkey = s.customerkey 
where s.orderdate >= '2025-06-01'
group by 1 ,2),
base2 as(
select *
,'2026-01-01'::date  - a.last_purchase  as timesince
from base a
where a.order_number >= 5)
select* 
,case 
	when a2.timesince  > 180 then 'high risk'
	when a2.timesince > 90 then 'medium risk'
	else 'low risk '
end as customer_chrunk
from base2 a2