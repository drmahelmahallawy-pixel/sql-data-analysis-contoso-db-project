--with base as (select s.customerkey 
--,sum(s.quantity *s.netprice ) as _total_cust_revenue
--,(count(distinct s.orderkey )*1.0) /count (distinct date_trunc('month',s.orderdate)) as purchase_fequnecy
--,'2025-12-31'::date  -  max(s.orderdate ) recency
--,count(distinct p.categorykey ) as category_diversity
--,max(s.orderdate ) - min(s.orderdate ) customer_tenur
--from sales s 
--join product p 
--on s.productkey = p.productkey 
--where s.orderdate >= '2020-01-01'
--group by 1
--),
-- aov1 as (
--select s1.customerkey 
--,s1.orderkey 
--,sum(s1.quantity*s1.netprice ) order_revenue
--,ntile(2) over (partition by s1.customerkey order by min( s1.orderdate) )  as order_half
--from sales s1
--group by 1,2 ),
--aov2 as(
--select b1.customerkey ,
--avg (case when  b1.order_half = 1 then b1.order_revenue  end )as aov_half_1
--,avg (case when  b1.order_half = 2 then b1.order_revenue else 0 end )as aov_half_2
--from aov1 b1
--group by b1.customerkey ),
--finalaov as (select *,case when b2.aov_half_1 > b2.aov_half_2  then 'decreasing'
--			  when  b2.aov_half_1 < b2.aov_half_2  then 'increasing'
--			  else 'flat'
--			end as aov_trend
--from aov2 b2)
--select a1.customerkey ,a1._total_cust_revenue,a1.purchase_fequnecy ,a1.recency ,a1.category_diversity ,a1.customer_tenur 
--,b5.aov_trend 
--,round(a1.recency / a1.purchase_fequnecy  ,2) as days_until_next_order
--from base a1 
--left join finalaov b5
--on a1.customerkey = b5.customerkey 
----problem 12.4
with base as (select s.orderdate as revenue_date
,round(sum(s.quantity * s.netprice),1) as daily_revenue 
from sales s
group by 1
),
base2 as(
select *
,avg(a1.daily_revenue ) over (order by a1.revenue_date rows between 30 preceding and 1 preceding ) as avg_daily
,stddev(a1.daily_revenue ) over (order by a1.revenue_date rows between 30 preceding and 1 preceding ) as stddev_daily
from base a1 )
select a2.revenue_date 
, case 
		when a2.daily_revenue > (a2.avg_daily + (2*a2.stddev_daily )) then '1'
		when a2.daily_revenue <= (a2.avg_daily + (2*a2.stddev_daily )) then '0'
		else '0'
end as anomaly
from base2 a2