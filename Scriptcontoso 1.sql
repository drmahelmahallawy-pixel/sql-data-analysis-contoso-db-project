--with base as (
--select
--	sum(sl.unitprice * sl.quantity ) as total_revenue
--,
--	sum(sl.unitcost * sl.quantity ) as total_cost
--,
--	count(distinct sl.customerkey ) as customer_n
--,
--	count(distinct sl.orderkey ) as orders_n
--,
--	sum(sl.quantity) as units
--from
--	sales sl
--where
--	sl.orderdate >= to_date( '2025-01-01', 'yyyy-mm-dd')
--	and sl.orderdate < to_date( '2025-04-01', 'yyyy-mm-dd')
--),
--step2 as (
--select
--	a1.*,
--	a1.total_revenue -a1.total_cost as profit
--from
--	base a1
--)
--select
--	a2.*,
--	round(a2.total_revenue / a2.orders_n, 2) as average_order_value,
--	round(a2.profit / nullif(a2.total_revenue, 0), 2) as profit_margin
--from
--	step2 as a2
--with base as (
--select
--	date_trunc('year', sl.orderdate) as year,
--	sum(sl.unitprice * sl.quantity ) as revenue,
--	count(distinct sl.orderkey ) as order_n
--from
--	sales sl
--where
--	sl.orderdate >= to_date('2016-01-01', 'yyyy-mm-dd')
--	and sl.orderdate <to_date('2018-01-01', 'yyyy-mm-dd')
--group by
--	1
--),
--step2 as (
--select
--	a1.*,
--	lag(a1.revenue) over (order by a1."year" ) as last_year,
--	lag(a1.order_n ) over (order by a1."year" ) as l_orders
--from
--	base a1)
--select a2.*,
--a2.revenue -a2.last_year  as growth ,
--(a2.revenue-a2.last_year )/a2.last_year as growth_percent,
--a2.order_n-a2.l_orders as order_growth,
--(a2.order_n-a2.l_orders)/a2.l_orders  as order_growth_percent
--from step2 a2
--where a2.last_year is not null 
--select p.categoryname ,
--sum(s.quantity *s.netprice ) total_revenue,
--sum(s.quantity ) units_sold
--from sales s
--inner join product p 
--on p.productkey =s.productkey 
--where s.orderdate >=to_date('2025-01-01','yyyy-mm-dd')
--and s.orderdate < to_date('2025-04-01','yyyy-mm-dd')
--group by p.categoryname 
--order by total_revenue  desc
with base as (
select c.customerkey ,
concat(c.givenname ,' ',c.surname )
,c.country 
,count (distinct s.orderkey )  orders
,sum(s.quantity *s.netprice )  revenue
,min(s.orderdate ) first_date,
max(s.orderdate ) last_date
, (max(s.orderdate )-min(s.orderdate )) as period
from sales s
inner join customer c 
on s.customerkey =c.customerkey 
where s.orderdate >= to_date('2025-01-01','yyyy-mm-dd')
and s.orderdate < to_date('2025-04-01','yyyy-mm-dd')
group by c.customerkey  ) ,
rfm  as (select a1.*,a1.revenue /nullif(a1.orders ,0) as avg_order
,ntile(4)over (order by a1.last_date desc) as r_score
,ntile(4)over (order by a1.orders  desc) as f_score
,ntile(4)over (order by a1.revenue   desc) as m_score
from base a1),
mah as (
select *,f_score+m_score+r_score as rfm_score from rfm )
select *,
case when mah.rfm_score >11 then 'VIP_loyaltyl'
when mah.rfm_score >7 then 'loyal'
when mah.rfm_score >4 then  'low_loyal'
when mah.rfm_score <=4 then 'not_loyal'  end as loyalty 
from mah