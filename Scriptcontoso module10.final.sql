-problem 10.1
select s.productkey 
,s.customerkey 
,sum(s.quantity *s.netprice ) revenue
from sales s
left join customer c 
on s.customerkey = c.customerkey 
where s.customerkey is null
group by 1,2
--,
--select s.productkey 
--,s.customerkey 
--,sum(s.quantity *s.netprice ) revenue
--from sales s
--left join product  p 
--on s.productkey = p.productkey 
--where s.productkey is null
--group by 1,2
select *
from orderrows o2 
left join orders o 
on o2.orderkey = o.orderkey
where o2.orderkey is null 
---- problem 10.2
select c.givenname ,c.surname,c.city,c.streetaddress   ,count(*)
from customer c
group by 1,2,3,4
having count(*) > 1
--problem 10.3
select count(*)
,count (s.productkey   ) not_null
from sales s 
select count(*)
,count (s.givenname  ) not_null
from customer s 
select count(*)
,count (p.productname    ) not_null
from product p  
select count(*)
,count (d."year"    ) not_null
from "date" d 
--Problem 10.4
select s.netprice < s.unitcost  as violation ,count(*)
from sales s
where s.netprice < s.unitcost
group by 1 
union all 
select s.quantity <0   ,count(*)
from sales s
where s.quantity <0
group by 1 
union all 
select o.deliverydate < o.orderdate    ,count(*)
from orders o 
where o.deliverydate < o.orderdate 
group by 1 
union all 
select c.exchange <=0    ,count(*)
from currencyexchange c  
where c.exchange <=0  
group by 1
union all 
select s.unitcost  > s.UnitPrice , count(*)
from sales s
where s.unitcost  > s.UnitPrice 
group by 1