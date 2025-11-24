{{ config(
    materialized='table'
) }}

WITH silver_division AS (
    SELECT * FROM {{ ref('stg_ufc__division') }} 

) SELECT * FROM silver_division
