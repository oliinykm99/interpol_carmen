{{ config(
    materialized='table',
    schema='analytics'
) }}

WITH distinct_witnesses AS (
    SELECT DISTINCT witness
    FROM {{ ref('int_observations') }}
    WHERE witness IS NOT NULL
)

SELECT
    ROW_NUMBER() OVER (ORDER BY witness) AS witness_id,
    witness AS name
FROM distinct_witnesses