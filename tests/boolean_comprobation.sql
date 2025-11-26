SELECT *
FROM {{ source('raw', 'fight_details') }}
WHERE title_fight != 0 AND title_fight != 1

        
        