{{ config(
    materialized='view',
    schema='analytics'
) }}

WITH behavior_counts AS (
    SELECT
        behavior,
        COUNT(*) AS occurrences
    FROM {{ ref('fact_observation') }}
    WHERE behavior IS NOT NULL
    GROUP BY behavior
)

SELECT
    behavior,
    occurrences
FROM behavior_counts
ORDER BY occurrences DESC
LIMIT 3