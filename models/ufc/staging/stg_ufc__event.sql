{{
  config(
    materialized='view'
  )
}}

WITH src_ufc AS (
    SELECT DISTINCT e.event_id, event_name, date, location
    FROM {{ ref('base_ufc__event_details') }} e
    INNER JOIN {{ ref('base_ufc__fight_details') }} f  ON e.event_id=f.event_id
    ),

event_view AS (

    SELECT 
        event_id,
        event_name,
        {{date_format_changer('date') }} AS date,
        location AS event_location, 

    FROM src_ufc

)SELECT * FROM event_view