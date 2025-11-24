{{ config(
    materialized='incremental'
) }}

WITH silver_fight_performance AS (
    SELECT fp.*, 
    event_id,
    division_id,
    referee_id,
    method_id,
    finish_round,
    fight_time_sec
    FROM {{ ref('stg_ufc__fight_performance') }} fp
    INNER JOIN {{ ref('stg_ufc__fight') }} f ON f.fight_id=fp.fight_id
),

fight_performance_table AS(
    SELECT 
    fight_performance_id,
    fight_id,
    fight_date,
    fighter_id,
    event_id,
    division_id,
    referee_id,
    method_id,
    finish_round,
    fight_time_sec,
    winner,
    knockdowns_landed ,                
    significant_strikes_landed,
    significant_strikes_attempted ,    
    significant_strikes_accuracy_percentage ,     
    total_strikes_landed  ,
    total_strikes_attempted ,
    total_strikes_accuracy_percentage ,   
    takedowns_landed ,       
    takedowns_attempted ,      
    takedowns_accuracy_percentage ,          
    submission_attempts ,         
    control_over_the_rival_in_seconds ,               
    significant_head_strikes_landed ,     
    significant_head_strikes_attempted ,   
    significant_head_strikes_accuracy_percentage  ,        
    significant_body_strikes_landed ,       
    significant_body_strikes_attempted ,   
    significant_body_strikes_accuracy_percentage ,           
    leg_kicks_landed  ,     
    leg_kicks_attempted  ,      
    leg_kicks_accuracy_percentage ,             
    significant_distance_strikes_landed,     
    significant_distance_strikes_attempted ,    
    significant_distance_strikes_accuracy_percentage ,        
    significant_clinch_strikes_landed ,    
    significant_clinch_strikes_attempted ,  
    significant_clinch_strikes_accuracy_percentage ,        
    significant_ground_strikes_landed ,     
    significant_ground_strikes_attempted ,    
    significant_ground_strikes_accuracy_percentage ,         
    significant_head_strikes_landed_percentage , 
    significant_body_strikes_landed_percentage , 
    significant_leg_strikes_landed_percentage,     
    significant_distance_strikes_landed_percentage,  
    significant_clinch_strikes_landed_percentage,
    significant_ground_strikes_landed_percentage

    FROM silver_fight_performance 
    
) SELECT * FROM fight_performance_table

{% if is_incremental() %}

  where fight_date > (select max(fight_date) from {{ this }})

{% endif %}