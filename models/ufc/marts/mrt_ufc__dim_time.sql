{{ config(
    materialized='table'
) }}

WITH dates AS (

    {{ dbt_utils.date_spine(
        start_date="cast('1990-01-01' as date)",
        end_date="cast('2050-01-01' as date)",
        datepart="day"
    ) }}

)

SELECT
    date_day                     AS date_id,
    extract(year  from date_day) AS year,
    extract(month from date_day) AS month,
    extract(day   from date_day) AS day
FROM dates
ORDER BY date_day
