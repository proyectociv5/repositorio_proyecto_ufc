{{ config(
    materialized='table'
) }}

WITH silver_referee AS (
    SELECT * FROM {{ ref('stg_ufc__referee') }} 

) SELECT * FROM silver_referee
