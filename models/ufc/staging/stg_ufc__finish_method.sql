{{
  config(
    materialized='view'
  )
}}

WITH distinct_method AS (
    SELECT DISTINCT method
    FROM {{ source('raw', 'fight_details') }}
),

method_view AS (

    SELECT 
        {{dbt_utils.generate_surrogate_key(['method'])}} AS method_id,
        method AS method_name

    FROM distinct_method

)SELECT * FROM method_view