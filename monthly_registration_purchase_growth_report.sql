USE db_course_conversions;

WITH tmp AS (
    SELECT 
        e.student_id,
        i.date_registered,
        MIN(e.date_watched) AS first_date_watched,
        MIN(p.date_purchased) AS first_date_purchased,
        DATEDIFF(MIN(e.date_watched), MIN(i.date_registered)) AS days_diff_reg_watch,
        DATEDIFF(MIN(p.date_purchased), MIN(e.date_watched)) AS days_diff_watch_purch
    FROM
        student_engagement e
    JOIN 
        student_info i ON e.student_id = i.student_id
    LEFT JOIN
        student_purchases p ON e.student_id = p.student_id
    GROUP BY 
        e.student_id
    HAVING 
        first_date_watched <= first_date_purchased OR first_date_purchased IS NULL
)

SELECT 
    registration_month,
    num_purchased,
    -- cumulative sum of purchases ordered by registration month
    SUM(num_purchased) OVER (ORDER BY registration_month) AS cumulative_purchased,
    -- growth rate compared to previous month, formatted as percentage string
    CASE
        WHEN LAG(num_purchased) OVER (ORDER BY registration_month) IS NULL THEN 0
        ELSE CONCAT(
            ROUND(
                (num_purchased - LAG(num_purchased) OVER (ORDER BY registration_month)) 
                / LAG(num_purchased) OVER (ORDER BY registration_month) * 100
                , 2
            ),
            '%'
        )
    END AS growth_rate
FROM (
    SELECT 
        DATE_FORMAT(date_registered, '%Y-%m') AS registration_month,
        SUM(CASE WHEN first_date_purchased IS NOT NULL THEN 1 ELSE 0 END) AS num_purchased
    FROM tmp
    GROUP BY registration_month
) AS monthly_purchase
ORDER BY registration_month;
