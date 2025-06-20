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

-- Create a pivot table to analyze each month's:
-- (1) Number of students who registered but never watched a lecture
-- (2) Number of students who registered and did watch a lecture
-- (3) Among those who watched, number who did NOT purchase
-- (4) Among those who watched, number who DID purchase
SELECT 
    DATE_FORMAT(date_registered, '%Y-%m') AS registration_month,
    SUM(CASE WHEN days_diff_reg_watch IS NULL THEN 1 ELSE 0 END) AS reg_not_watch,
    SUM(CASE WHEN days_diff_reg_watch IS NOT NULL THEN 1 ELSE 0 END) AS reg_watch,
    SUM(CASE WHEN days_diff_watch_purch IS NULL THEN 1 ELSE 0 END) AS watch_not_purchase,
    SUM(CASE WHEN days_diff_watch_purch IS NOT NULL THEN 1 ELSE 0 END) AS watch_purchase
FROM tmp
GROUP BY registration_month
ORDER BY registration_month;
