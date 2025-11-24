{{
  config(
    materialized='view'
  )
}}

SELECT * 
FROM {{ source('raw', 'fight_details') }}

