with last_customer_purchase AS 
    (SELECT
        customerkey,
        cleaned_name,
        orderdate,
        row_number() OVER(PARTITION BY customerkey ORDER BY orderdate DESC) AS rn
    FROM 
        cohort_analysis)

SELECT
    customerkey,
    cleaned_name,
    orderdate as last_order_date,
    CASE
        WHEN orderdate < (SELECT MAX(orderdate) FROM sales) - INTERVAL '6 Months' THEN 'churned'
        ELSE 'active'
    END as customer_status
FROM
    last_customer_purchase
WHERE
    rn = 1
    AND orderdate < (SELECT MAX(orderdate) FROM sales) - INTERVAL '6 Months'