--problem 11.1
--select p.productname,p2.productname  ,
--count (*)
--from orderrows o
--join orderrows o2 on o.orderkey = o2.orderkey
--and o.productkey > o2.productkey 
--join product p 
--on o.productkey = p.productkey 
--join product p2 
--on p2.productkey = o2.productkey 
--where o.orderkey >= 10000
--group by 1,2
----problem 11.2
--with base as (select s.customerkey ,concat(c.givenname , ' ',c.surname )as customer_name ,
--count(s.orderkey ) as order_number,
--max(s.orderdate )  last_purchase
--from sales s
--join customer c 
--on c.customerkey = s.customerkey 
--where s.orderdate >= '2025-06-01'
--group by 1 ,2),
--base2 as(
--select *
--,'2026-01-01'::date  - a.last_purchase  as timesince
--from base a
--where a.order_number >= 5)
--select* 
--,case 
--	when a2.timesince  > 180 then 'high risk'
--	when a2.timesince > 90 then 'medium risk'
--	else 'low risk '
--end as customer_chrunk
--from base2 a2
----problem 11.3
--WITH base AS (
--    SELECT 
--        s.productkey,
--        s.orderdate,
--        s.unitprice AS price,
--        s.quantity,
--        LAG(s.unitprice) OVER (
--            PARTITION BY s.productkey 
--            ORDER BY s.orderdate
--        ) AS prev_price
--    FROM sales s
--),
--price_changes AS (
--    SELECT 
--        productkey,
--        orderdate,
--        price,
--        prev_price
--    FROM base
--    WHERE prev_price IS NOT NULL
--      AND price <> prev_price
--)
--SELECT
--    pc.productkey,
--    pc.orderdate AS change_date,
--    pc.prev_price AS old_price,
--    pc.price AS new_price,
--    AVG(
--        CASE 
--            WHEN s.orderdate >= pc.orderdate - INTERVAL '30 days'
--             AND s.orderdate <  pc.orderdate
--            THEN s.quantity
--        END
--    ) AS vol_before,
--    AVG(
--        CASE 
--            WHEN s.orderdate >= pc.orderdate
--             AND s.orderdate <= pc.orderdate + INTERVAL '30 days'
--            THEN s.quantity
--        END
--    ) AS vol_after
--FROM price_changes pc
--JOIN sales s
--    ON s.productkey = pc.productkey
--   AND s.orderdate BETWEEN pc.orderdate - INTERVAL '30 days'
--                       AND pc.orderdate + INTERVAL '30 days'
--GROUP BY
--    pc.productkey,
--    pc.orderdate,
--    pc.prev_price,
--    pc.price;
--problem 11.4
--with base as (select s.productkey 
--,sum(s.quantity *s.netprice ) as revenue 
--from sales s
--group by 1
--),
--base2 as (select *
--,ntile(100) over ( order by a1.revenue desc ) as perc_revenue
--from base a1),
--base3 as (select *
--,case when a2.perc_revenue <= 20 then 'class a'
--	  when a2.perc_revenue <= 50 then 'class b'
--	  else 'class c'
--end as invemntory_class
--from base2 a2),
--base4 as (
--select a3.invemntory_class 
--,sum(a3.revenue ) class_revenue
--,(select sum(s.quantity*s.netprice) from sales s ) as total_revenue
--from base3 a3
--group by 1)
--select *
--,round((a4.class_revenue /a4.total_revenue *100),2) class_percent
--from base4 a4
----another solution 
with base as (select s.productkey 
, sum (s.quantity *s.netprice ) as revenue 
,(select round(sum(s.quantity*s.netprice ),2) from sales s) as total_revenue
from sales s
group by 1),
base2 as (select * 
,sum(a1.revenue ) over (order by a1.revenue desc) as runt_revenue
from base a1 ),
base3 as (select *,round((a2.runt_revenue / a2.total_revenue *100),2) as revenue_percent
from base2 a2)
select *
, case
	when a3.revenue_percent <= 80 then 'class A'
	when a3.revenue_percent <= 95 then 'class B'
	else 'class C'
end as inventory_class
from base3 a3