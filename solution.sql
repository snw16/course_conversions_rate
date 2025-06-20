SELECT 
    ROUND(COUNT(a.first_date_purchased) / COUNT(a.student_id) * 100, 2) AS conversion_rate,
    ROUND(SUM(a.days_diff_reg_watch) / COUNT(a.student_id), 2) AS av_reg_watch,
    ROUND(SUM(a.days_diff_watch_purch) / COUNT(a.first_date_purchased), 2) AS av_watch_purch
FROM
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
    ) a;

