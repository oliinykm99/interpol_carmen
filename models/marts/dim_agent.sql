{{ config(
    materialized='table',
    schema='analytics'
) }}

WITH distinct_agents AS (
    SELECT DISTINCT agent
    FROM {{ ref('int_observations') }}
    WHERE agent IS NOT NULL
)

SELECT
    ROW_NUMBER() OVER (ORDER BY agent) AS agent_id,
    agent AS name
FROM distinct_agents