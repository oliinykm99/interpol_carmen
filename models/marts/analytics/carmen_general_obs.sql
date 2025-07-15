{{ config(
    materialized='view',
    schema='analytics'
) }}

WITH monthly_counts AS (
    SELECT
        TO_CHAR(date_trunc('month', date_witness), 'YYYY-MM') AS month,
        COUNT(*) AS total_observations,
        SUM(
            CASE
                WHEN has_weapon = TRUE AND has_jacket = TRUE AND has_hat = FALSE THEN 1
                ELSE 0
            END
        ) AS condition_observations
    FROM {{ ref('fact_observation') }}
    GROUP BY month
)

SELECT
    month,
    condition_observations,
    total_observations,
    ROUND(condition_observations::numeric / NULLIF(total_observations, 0) * 100, 4) AS probability
FROM monthly_counts
ORDER BY month