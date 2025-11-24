{{ config(
    materialized='table'
) }}

WITH silver_fighter AS (
    SELECT * FROM {{ ref('stg_ufc__fighter') }} f
    INNER JOIN {{ ref('stg_ufc__stance') }} s ON f.stance_id =s.stance_id
),

dim_fighter AS(

    SELECT 
    fighter_id,
    name,
    nick_name,
    date_of_birthay,
    height,
    reach,
    fighter_stance

    FROM silver_fighter 
    
) SELECT * FROM dim_fighter
