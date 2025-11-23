{{
  config(
    materialized='view'
  )
}}

WITH distinct_division AS (
    SELECT DISTINCT division
    FROM {{ source('raw', 'fight_details') }}
),

division_view AS (

    SELECT 
        {{dbt_utils.generate_surrogate_key(['division'])}} AS division_id,
        division AS division_name

    FROM distinct_division

)SELECT * FROM division_view