{{ config(
    materialized='table',
    schema='analytics'
) }}

WITH observations AS (
    SELECT * FROM {{ ref('int_observations') }}
),

witnesses AS (
    SELECT witness_id, name FROM {{ ref('dim_witness') }}
),

agents AS (
    SELECT agent_id, name FROM {{ ref('dim_agent') }}
),

locations AS (
    SELECT * FROM {{ ref('dim_location') }}
),

region_sources AS (
    SELECT * FROM {{ ref('dim_region') }}
)

SELECT
    ROW_NUMBER() OVER () AS observation_id,
    o.date_witness,
    o.date_agent,
    w.witness_id,
    a.agent_id,
    l.location_id,
    rs.region_id,
    o.has_weapon,
    o.has_hat,
    o.has_jacket,
    o.behavior
FROM observations o
LEFT JOIN witnesses w ON o.witness = w.name
LEFT JOIN agents a ON o.agent = a.name
LEFT JOIN locations l 
  ON o.latitude = l.latitude
  AND o.longitude = l.longitude
  AND o.city = l.city
  AND ( (o.country = l.country) OR (o.country IS NULL AND l.country = 'UNKNOWN') )
  AND ( (o.region_hq = l.region_hq) OR (o.region_hq IS NULL AND l.region_hq = 'UNKNOWN') )
LEFT JOIN region_sources rs ON o.region_source = rs.region_source