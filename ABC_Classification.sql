WITH base AS (
    SELECT productkey, SUM(quantity * netprice) AS revenue
    FROM sales GROUP BY 1
),
base2 AS (
    SELECT productkey, revenue,
    SUM(revenue) OVER (ORDER BY revenue DESC) AS cumulative_revenue,
    SUM(revenue) OVER () AS total_revenue
    FROM base
),
base3 AS (
    SELECT productkey, revenue,
    (cumulative_revenue / total_revenue) * 100 AS cumulative_percentage
    FROM base2
)
SELECT productkey, revenue, cumulative_percentage,
CASE 
    WHEN cumulative_percentage <= 80 THEN 'class a'
    WHEN cumulative_percentage <= 95 THEN 'class b'
    ELSE 'class c'
END AS inventory_class
FROM base3 ORDER BY revenue DESC;
