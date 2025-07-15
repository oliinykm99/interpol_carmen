{{ config(
    materialized='view',
    schema='analytics'
) }}

WITH region_counts AS (
    SELECT
        TO_CHAR(date_trunc('month', date_witness), 'YYYY-MM') AS month,
        region_id,
        COUNT(*) AS observations
    FROM {{ ref('fact_observation') }}
    GROUP BY month, region_id
),

ranked_regions AS (
    SELECT
        month,
        region_id,
        observations,
        ROW_NUMBER() OVER (PARTITION BY month ORDER BY observations DESC) AS rn
    FROM region_counts
)

SELECT
    rr.month,
    r.region_source,
    rr.observations
FROM ranked_regions rr
LEFT JOIN {{ ref('dim_region') }} r ON rr.region_id = r.region_id
WHERE rr.rn = 1
ORDER BY rr.month