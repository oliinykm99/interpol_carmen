{{ config(
    materialized='table',
    schema='analytics'
) }}

WITH deduped AS (
    SELECT DISTINCT
        latitude,
        longitude,
        city,
        COALESCE(country, 'UNKNOWN') AS country,
        COALESCE(region_hq, 'UNKNOWN') AS region_hq
    FROM {{ ref('int_observations') }}
)

SELECT
    ROW_NUMBER() OVER (ORDER BY city, country, latitude, longitude, region_hq) AS location_id,
    latitude,
    longitude,
    city,
    country,
    region_hq
FROM deduped