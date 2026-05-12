WITH customer_ltv AS (
    SELECT
        customerkey,
        cleaned_name,
        SUM(net_revenue) AS total_ltv
    FROM 
        cohort_analysis
    GROUP BY 
        customerkey,
        cleaned_name
),
 customer_percentile AS
    (SELECT
        PERCENTILE_CONT(0.25) WITHIN GROUP ( ORDER BY total_ltv) AS customer_25_percentile,
        PERCENTILE_CONT(0.75) WITHIN GROUP ( ORDER BY total_ltv) AS customer_75_percentile
    FROM 
    customer_ltv),
 customer_segmentation AS 
    (SELECT 
        *,
        CASE
            WHEN total_ltv < customer_25_percentile THEN '1-LOW-VALUE'
            WHEN total_ltv <= customer_75_percentile THEN '2-MEDIUM-VALUE'
            ELSE '3-HIGH-VALUE'
        END as customer_segment
    FROM 
        customer_ltv,
        customer_percentile)


SELECT 
    customer_segment,
    SUM(total_ltv) AS total_ltv,
    COUNT(customerkey) as customer_count,
    SUM(total_ltv) / COUNT(customerkey) AS avg_ltv
FROM
    customer_segmentation
GROUP BY 
        customer_segment