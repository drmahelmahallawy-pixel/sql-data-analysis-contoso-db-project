--
--with base as (
--select c.customerkey ,
--concat(c.givenname ,' ',c.surname )
--,c.country 
--,count (distinct s.orderkey )  orders
--,sum(s.quantity *s.netprice )  revenue
--,min(s.orderdate ) first_date,
--max(s.orderdate ) last_date
--, (max(s.orderdate )-min(s.orderdate )) as period
--from sales s
--inner join customer c 
--on s.customerkey =c.customerkey 
--where s.orderdate >= to_date('2025-01-01','yyyy-mm-dd')
--and s.orderdate < to_date('2025-04-01','yyyy-mm-dd')
--group by c.customerkey  ) ,
--rfm  as (select a1.*,a1.revenue /nullif(a1.orders ,0) as avg_order
--,ntile(4)over (order by a1.last_date desc) as r_score
--,ntile(4)over (order by a1.orders  desc) as f_score
--,ntile(4)over (order by a1.revenue   desc) as m_score
--from base a1),
--mah as (
--select *,f_score+m_score+r_score as rfm_score from rfm )
--select *,
--case when mah.rfm_score >11 then 'VIP_loyaltyl'
--when mah.rfm_score >7 then 'loyal'
--when mah.rfm_score >4 then  'low_loyal'
--when mah.rfm_score <=4 then 'not_loyal'  end as loyalty 
--from mah
--
with base as ( 
select
d."date"  
,d."year" 
,sum(s.netprice *s.quantity) revenue
, date_part('month',s.orderdate) as month
,count(distinct s.orderkey ) as order_numbers
from sales s
inner join "date" d on s.orderdate =d."date" 
where s.orderdate >= to_date('2025-01-01','yyyy-mm-dd')
and s.orderdate < to_date('2025-11-01','yyyy-mm-dd')
group by 1,2,4),
base2 as (
select *
,round(a1.revenue /a1.order_numbers,2) as avg_per_order
,lag (a1.revenue) over (partition by a1."month" order by a1."year" ,a1.month ) as last_month_rev
,sum(a1.revenue) over (  order by a1."date" ) as ytd
,(100000000/365)*date_part('doy',a1."date" ) as ytd_target
from base a1
)
select a2.*
,round(cast(a2.ytd/a2.ytd_target as numeric),3) as achievement
,round((a2.revenue -a2.last_month_rev )/nullif(a2.last_month_rev,0) *100,2) as growth_percent
from base2 a2