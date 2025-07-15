{{ config(
    materialized='table',
    schema='analytics'
) }}

WITH all_regions AS (
    SELECT * FROM {{ ref('stg_africa') }}
    UNION ALL
    SELECT * FROM {{ ref('stg_america') }}
    UNION ALL
    SELECT * FROM {{ ref('stg_asia') }}
    UNION ALL
    SELECT * FROM {{ ref('stg_atlantic') }}
    UNION ALL
    SELECT * FROM {{ ref('stg_australia') }}
    UNION ALL
    SELECT * FROM {{ ref('stg_europe') }}
    UNION ALL
    SELECT * FROM {{ ref('stg_indian') }}
    UNION ALL
    SELECT * FROM {{ ref('stg_pacific') }}
)

SELECT
    *
FROM all_regions