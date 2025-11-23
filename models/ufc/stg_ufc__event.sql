{{
  config(
    materialized='view'
  )
}}

WITH src_ufc AS (
    SELECT DISTINCT e.event_id, event_name, date, location
    FROM {{ source('raw', 'event_details') }} e
    INNER JOIN {{ source('raw', 'fight_details') }} f  ON e.event_id=f.event_id
    ),

event_view AS (

    SELECT 
        event_id,
        event_name,
        {{date_format_changer('date') }} AS date,
        location AS event_location, 

    FROM src_ufc

)SELECT * FROM event_view