{{
  config(
    materialized='incremental'
  )
}}

WITH one_row_per_fighter AS (
    SELECT  fight_id, r_id AS fighter_id, 
    r_kd AS   knockdowns_landed ,                 
    r_sig_str_landed AS significant_strikes_landed ,
    r_sig_str_atmpted AS significant_strikes_attempted ,    
    r_sig_str_acc AS significant_strikes_accuracy_percentage   ,   
    r_total_str_landed AS  total_strikes_landed , 
    r_total_str_atmpted AS total_strikes_attempted, 
    r_total_str_acc AS  total_strikes_accuracy_percentage  ,  
    r_td_landed  AS takedowns_landed ,       
    r_td_atmpted AS takedowns_attempted  ,     
    r_td_acc  AS takedowns_accuracy_percentage ,          
    r_sub_att AS  submission_attempts ,         
    r_ctrl AS  control_over_the_rival_in_seconds ,               
    r_head_landed  AS  significant_head_strikes_landed ,     
    r_head_atmpted AS  significant_head_strikes_attempted ,   
    r_head_acc AS significant_head_strikes_accuracy_percentage ,         
    r_body_landed AS significant_body_strikes_landed  ,      
    r_body_atmpted  AS significant_body_strikes_attempted ,   
    r_body_acc AS significant_body_strikes_accuracy_percentage ,           
    r_leg_landed  AS  leg_kicks_landed ,      
    r_leg_atmpted AS  leg_kicks_attempted,        
    r_leg_acc AS  leg_kicks_accuracy_percentage ,             
    r_dist_landed AS   significant_distance_strikes_landed ,    
    r_dist_atmpted AS  significant_distance_strikes_attempted ,    
    r_dist_acc  AS  significant_distance_strikes_accuracy_percentage ,        
    r_clinch_landed AS  significant_clinch_strikes_landed,     
    r_clinch_atmpted AS  significant_clinch_strikes_attempted,   
    r_clinch_acc AS significant_clinch_strikes_accuracy_percentage  ,       
    r_ground_landed AS  significant_ground_strikes_landed ,     
    r_ground_atmpted AS significant_ground_strikes_attempted,     
    r_ground_acc AS significant_ground_strikes_accuracy_percentage,          
    r_landed_head_per  AS significant_head_strikes_landed_percentage , 
    r_landed_body_per AS  significant_body_strikes_landed_percentage , 
    r_landed_leg_per AS  significant_leg_strikes_landed_percentage ,    
    r_landed_dist_per AS  significant_distance_strikes_landed_percentage, 
    r_landed_clinch_per  AS significant_clinch_strikes_landed_percentage,
    r_landed_ground_per AS  significant_ground_strikes_landed_percentage
    FROM {{ source('raw', 'fight_details') }}

    UNION ALL

    SELECT  fight_id, b_id AS fighter_id, 
    b_kd AS   knockdowns_landed ,                
    b_sig_str_landed AS significant_strikes_landed,
    b_sig_str_atmpted AS significant_strikes_attempted ,    
    b_sig_str_acc AS significant_strikes_accuracy_percentage ,     
    b_total_str_landed AS  total_strikes_landed  ,
    b_total_str_atmpted AS total_strikes_attempted ,
    b_total_str_acc AS  total_strikes_accuracy_percentage ,   
    b_td_landed  AS takedowns_landed ,       
    b_td_atmpted AS takedowns_attempted ,      
    b_td_acc  AS takedowns_accuracy_percentage ,          
    b_sub_att AS  submission_attempts ,         
    b_ctrl AS  control_over_the_rival_in_seconds ,               
    b_head_landed  AS  significant_head_strikes_landed ,     
    b_head_atmpted AS  significant_head_strikes_attempted ,   
    b_head_acc AS significant_head_strikes_accuracy_percentage  ,        
    b_body_landed AS significant_body_strikes_landed ,       
    b_body_atmpted  AS significant_body_strikes_attempted ,   
    b_body_acc AS significant_body_strikes_accuracy_percentage ,           
    b_leg_landed  AS  leg_kicks_landed  ,     
    b_leg_atmpted AS  leg_kicks_attempted  ,      
    b_leg_acc AS  leg_kicks_accuracy_percentage ,             
    b_dist_landed AS   significant_distance_strikes_landed,     
    b_dist_atmpted AS  significant_distance_strikes_attempted ,    
    b_dist_acc  AS  significant_distance_strikes_accuracy_percentage ,        
    b_clinch_landed AS  significant_clinch_strikes_landed ,    
    b_clinch_atmpted AS  significant_clinch_strikes_attempted ,  
    b_clinch_acc AS significant_clinch_strikes_accuracy_percentage ,        
    b_ground_landed AS  significant_ground_strikes_landed ,     
    b_ground_atmpted AS significant_ground_strikes_attempted ,    
    b_ground_acc AS significant_ground_strikes_accuracy_percentage ,         
    b_landed_head_per  AS significant_head_strikes_landed_percentage , 
    b_landed_body_per AS  significant_body_strikes_landed_percentage , 
    b_landed_leg_per AS  significant_leg_strikes_landed_percentage,     
    b_landed_dist_per AS  significant_distance_strikes_landed_percentage,  
    b_landed_clinch_per  AS significant_clinch_strikes_landed_percentage,
    b_landed_ground_per AS  significant_ground_strikes_landed_percentage
    FROM {{ source('raw', 'fight_details') }} ) ,

    join_with_event_details AS(

        SELECT f.*, e.winner_id 
        FROM one_row_per_fighter f
        INNER JOIN {{ source('raw', 'event_details') }} e ON f.fight_id = e.fight_id

    ) ,

    incremental_table AS(
        SELECT
        {{dbt_utils.generate_surrogate_key(['fight_id', 'fighter_id'])}} AS fighter_performance_id,
        fight_id,
        fighter_id,
        CAST(
            CASE 
                WHEN winner_id = fighter_id THEN TRUE
                WHEN winner_id != fighter_id THEN FALSE
            END
            AS BOOLEAN) AS winner,
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

        FROM join_with_event_details order by fight_id

    ) SELECT * FROM incremental_table






