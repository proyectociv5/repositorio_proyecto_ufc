{{
  config(
    materialized='view'
  )
}}

WITH distinct_referees AS (
    SELECT DISTINCT referee
    FROM {{ source('raw', 'fight_details') }}
),

referee_view AS (

    SELECT 
        {{dbt_utils.generate_surrogate_key(['referee'])}} AS referee_id,
        referee AS referee_name

    FROM distinct_referees

)SELECT * FROM referee_view