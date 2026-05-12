CREATE VIEW cohort_analysis as (

    WITH customer_details AS(
        SELECT
            s.customerkey,
            s.orderdate,
            SUM(s.quantity * s.unitprice* s.exchangerate) AS net_revenue,
            COUNT(s.orderkey) as order_num,
            CONCAT(trim(givenname), ' ',TRIM(surname)) as cleaned_name,
            c.countryfull,
            c.age,
            c.givenname,
            c.surname
        FROM 
            sales s
        LEFT JOIN 
            customer c ON s.customerkey = c.customerkey
        GROUP BY
            s.customerkey,
            s.orderdate,
            c.countryfull,
            c.age,
            c.givenname,
            c.surname)



    SELECT *,
        MIN(orderdate) OVER(PARTITION BY customerkey) first_purchase_date,
        EXTRACT(YEAR FROM MIN(orderdate) OVER(PARTITION BY customerkey)  ) cohort_year
    FROM 
        customer_details
);


select *
from cohort_analysis;