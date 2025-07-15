{{ config(
    materialized='table',
    schema='analytics'
) }}

WITH distinct_regions AS (
    SELECT DISTINCT region_source
    FROM {{ ref('int_observations') }}
    WHERE region_source IS NOT NULL
)

SELECT
    ROW_NUMBER() OVER (ORDER BY region_source) AS region_id,
    region_source
FROM distinct_regions