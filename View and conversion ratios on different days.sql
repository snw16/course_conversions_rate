USE db_course_conversions;

WITH tmp AS
(
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
    

-- Calculate the percentage of paid conversions occurring on the same day, within 1-7 days, 7-30 days, and over 30 days after first watching
SELECT 
    ROUND(SUM(CASE WHEN days_diff_watch_purch = 0 THEN 1 ELSE 0 END) / SUM(CASE WHEN days_diff_watch_purch IS NOT NULL THEN 1 ELSE 0 END), 2) AS same_day_purchase_percentage,
    ROUND(SUM(CASE WHEN days_diff_watch_purch BETWEEN 1 AND 7 THEN 1 ELSE 0 END) / SUM(CASE WHEN days_diff_watch_purch IS NOT NULL THEN 1 ELSE 0 END), 2) AS 1_to_7_days_purchase_percentage,
    ROUND(SUM(CASE WHEN days_diff_watch_purch BETWEEN 8 AND 30 THEN 1 ELSE 0 END) / SUM(CASE WHEN days_diff_watch_purch IS NOT NULL THEN 1 ELSE 0 END), 2) AS 7_to_30_days_purchase_percentage,
    ROUND(SUM(CASE WHEN days_diff_watch_purch > 30 THEN 1 ELSE 0 END) / SUM(CASE WHEN days_diff_watch_purch IS NOT NULL THEN 1 ELSE 0 END), 2) AS over_30_days_purchase_percentage
FROM tmp;

