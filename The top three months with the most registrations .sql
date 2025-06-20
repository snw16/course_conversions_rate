USE db_course_conversions;
WITH tmp AS (
    SELECT 
        e.student_id,                               -- Student ID
        i.date_registered,                          -- Registration date
        MIN(e.date_watched) AS first_date_watched,  -- First date the student watched content
        MIN(p.date_purchased) AS first_date_purchased, -- First purchase date, if any
        DATEDIFF(MIN(e.date_watched), MIN(i.date_registered)) AS days_diff_reg_watch, -- Days between registration and first watch
        DATEDIFF(MIN(p.date_purchased), MIN(e.date_watched)) AS days_diff_watch_purch -- Days between first watch and first purchase
    FROM
        student_engagement e                       -- Table of students watching content
    JOIN 
        student_info i ON e.student_id = i.student_id -- Join with registration info
    LEFT JOIN
        student_purchases p ON e.student_id = p.student_id -- Optional join with purchase info
    GROUP BY 
        e.student_id
    HAVING 
        first_date_watched <= first_date_purchased  -- Keep students where first watch is before or on first purchase date
        OR first_date_purchased IS NULL             -- OR the student never purchased
)
SELECT month_registered, num_students
FROM (
    SELECT 
        MONTH(date_registered) AS month_registered,  -- Extract month (1 = January, etc.)
        COUNT(*) AS num_students,                    -- Count students who registered in that month
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk  -- Rank months by number of registrations
    FROM tmp
    GROUP BY month_registered
) AS ranked_months
WHERE rnk <= 3;

