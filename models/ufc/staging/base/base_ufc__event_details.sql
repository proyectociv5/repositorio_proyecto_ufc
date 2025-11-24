{{
  config(
    materialized='view'
  )
}}

SELECT * 
FROM {{ source('raw', 'event_details') }}

