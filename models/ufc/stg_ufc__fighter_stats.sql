{{
  config(
    materialized='view'
  )
}}

WITH fighter_stats_snapshot AS (
    SELECT * 
    FROM {{ source('raw', 'fighter_details') }}
    ),

fighter_view AS (

    SELECT 
        id AS fighter_id,
        name,
        nick_name,
        {{date_format_changer('dob') }} AS date_of_birthay,
        height, 
        reach,
        {{dbt_utils.generate_surrogate_key(['stance'])}} AS stance_id

    FROM src_ufc

)SELECT * FROM fighter_view