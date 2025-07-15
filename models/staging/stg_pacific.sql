{{ config(
    materialized='view',
    schema='staging'
) }}

{{ rename_columns(source('interpol_raw', 'region_pacific'), 'pacific') }}