USE db_course_conversions;

WITH tmp AS (
    -- For each student, get registration date, first watched date, and first purchase date
    SELECT 
        e.student_id,
        i.date_registered,
        MIN(e.date_watched) AS first_date_watched,        -- Earliest date the student watched content
        MIN(p.date_purchased) AS first_date_purchased,    -- Earliest date the student made a purchase
        DATEDIFF(MIN(e.date_watched), MIN(i.date_registered)) AS days_diff_reg_watch,   -- Days between registration and first watch
        DATEDIFF(MIN(p.date_purchased), MIN(e.date_watched)) AS days_diff_watch_purch   -- Days between first watch and first purchase
    FROM
        student_engagement e
    JOIN 
        student_info i ON e.student_id = i.student_id      -- Join to get registration date
    LEFT JOIN
        student_purchases p ON e.student_id = p.student_id -- Left join to get purchase date (if any)
    GROUP BY 
        e.student_id
    HAVING 
        first_date_watched <= first_date_purchased         -- Only include students who watched before or at the same time as they purchased
        OR first_date_purchased IS NULL                    -- Or students who have never purchased
)

-- Calculate the number of students who registered on each day of the week
SELECT 
    DAYOFWEEK(date_registered) AS day_of_week,  -- Day of the week (1 = Sunday, 7 = Saturday)
    COUNT(*) AS num_students                    -- Number of students registered on that day
FROM
    tmp
GROUP BY 
    day_of_week
ORDER BY 
    day_of_week;                               -- Order results from Sunday to Saturday

