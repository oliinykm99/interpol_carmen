{{ config(
    materialized='view',
    schema='analytics'
) }}


WITH top_behaviors AS (
    SELECT behavior
    FROM {{ ref('carmen_top_behaviors') }}
),

monthly_behavior_counts AS (
    SELECT
        TO_CHAR(date_trunc('month', date_witness), 'YYYY-MM') AS month,
        COUNT(*) AS total_observations,
        SUM(
            CASE 
                WHEN behavior IN (SELECT behavior FROM top_behaviors) THEN 1
                ELSE 0
            END
        ) AS top_behavior_observations
    FROM {{ ref('fact_observation') }}
    GROUP BY month
)

SELECT
    month,
    top_behavior_observations,
    total_observations,
    ROUND(top_behavior_observations::numeric / NULLIF(total_observations, 0) * 100, 4) AS probability
FROM monthly_behavior_counts
ORDER BY month