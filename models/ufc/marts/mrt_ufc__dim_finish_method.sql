{{ config(
    materialized='table'
) }}

WITH silver_method AS (
    SELECT * FROM {{ ref('stg_ufc__finish_method') }} 

) SELECT * FROM silver_method
