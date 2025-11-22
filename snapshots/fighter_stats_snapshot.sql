{% snapshot fighter_stats_snapshot%}

{{
    config(
        target_schema='snapshots',
        unique_key='fighter_id',
        strategy='check',
        check_cols=[
            'wins',
            'losses',
            'draws',
            'weight',
            'significant_strikes_landed_per_minute',
            'striking_accuracy_percentage',
            'significant_strikes_absorbed_per_minute',
            'significant_strike_defense_percentage',
            'takedown_average_per_fight',
            'takedown_accuracy_percentage',
            'takedown_defense_percentage',
            'submission_average_per_fight']
    )
}}

SELECT
    id AS fighter_id,
    wins,
    losses,
    draws,
    weight,
    splm AS significant_strikes_landed_per_minute,
    str_acc AS striking_accuracy_percentage,
    sapm AS significant_strikes_absorbed_per_minute,
    str_def AS significant_strike_defense_percentage ,
    td_avg AS takedown_average_per_fight ,
    td_avg_acc AS takedown_accuracy_percentage,
    td_def AS takedown_defense_percentage,
    sub_avg AS submission_average_per_fight

FROM {{ source('raw', 'fighter_details') }}

{% endsnapshot %}