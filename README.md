# Course Conversions Rate Analysis

This project analyzes the free-to-paid conversion rates of students on the 365 Data Science platform using SQL.

## Project Description

The goal is to calculate key metrics such as:

- Free-to-paid conversion rate of students who have watched a lecture
- Average duration between registration and first-time engagement (lecture watched)
- Average duration between first-time engagement and first-time purchase (subscription)

The analysis is based on the `db_course_conversions` dataset.

## Files Included

- `db_course_conversions.sql` — SQL file to create and populate the database
- `solution.sql` — Main SQL queries for conversion rate and duration calculations
- Multiple additional `.sql` and `.csv` files for exploratory analysis:
  - View and conversion ratios on different days
  - Registration counts by month and day of the week
  - Monthly registration and purchase growth report
  - Monthly cohort engagement and purchase pivot

## How to Use

1. Import `db_course_conversions.sql` to your MySQL database.
2. Run the queries in `solution.sql` to reproduce the main analysis results.
3. Review other SQL and CSV files for extended insights.
