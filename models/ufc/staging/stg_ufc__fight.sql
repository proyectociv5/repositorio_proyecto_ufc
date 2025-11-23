{{
  config(
    materialized='view'
  )
}}

WITH src_ufc AS (
    SELECT * 
    FROM {{ source('raw', 'fight_details') }}
    ),

fight_view AS (

    SELECT 
        fight_id,
        event_id,
        {{dbt_utils.generate_surrogate_key(['division'])}} AS division_id,
        {{dbt_utils.generate_surrogate_key(['referee'])}} AS referee_id,
        {{dbt_utils.generate_surrogate_key(['method'])}} AS method_id, 
        CAST(
            CASE 
                WHEN title_fight = 1 THEN TRUE
                WHEN title_fight = 0 THEN FALSE
            END
            AS BOOLEAN) AS title_fight,
        finish_round,
        total_rounds,
        match_time_sec AS fight_time_sec

    FROM src_ufc

)SELECT * FROM fight_view