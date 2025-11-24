{{ config(
    materialized='table'
) }}

WITH silver_event AS (
    SELECT * FROM {{ ref('stg_ufc__event') }} 
),

event_table AS(

    SELECT 
    event_id,
    event_name,
    event_location

    FROM silver_event 
    
) SELECT * FROM event_table
