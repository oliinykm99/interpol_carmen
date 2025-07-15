{% macro rename_columns(source_table, region) %}
  {% set mappings = run_query(
      "SELECT source_column, target_column, dtype 
       FROM " ~ ref('column_mappings') ~ " 
       WHERE region = '" ~ region ~ "'"
  ) %}
  
SELECT
  {% for row in mappings %}
  "{{ row.source_column }}"::{{ row.dtype }} AS {{ row.target_column }}{% if not loop.last %},{% endif %}
  {% endfor %}
  , CURRENT_TIMESTAMP AS loaded_at
  , '{{ region }}' AS region_source
FROM {{ source_table }}
{% endmacro %}