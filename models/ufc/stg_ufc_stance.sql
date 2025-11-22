{{
  config(
    materialized='view'
  )
}}

WITH distinct_stances AS (
    SELECT DISTINCT stance
    FROM {{ source('raw', 'fighter_details') }}
),

stance_view AS (

    SELECT 
        {{dbt_utils.generate_surrogate_key(['stance'])}} AS stance_id,
        stance AS fighter_stance

    FROM distinct_stances

)SELECT * FROM stance_view