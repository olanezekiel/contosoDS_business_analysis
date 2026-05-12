SELECT
    cohort_year,
    COUNT(DISTINCT customerkey) as total_customer,
    SUM(net_revenue) as total_revenue,
    SUM(net_revenue)/COUNT(DISTINCT customerkey) as customer_revenue
FROM 
    cohort_anaylsis
WHERE 
    orderdate = first_purchase_date
GROUP BY
    cohort_year;

