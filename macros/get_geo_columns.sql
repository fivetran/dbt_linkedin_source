{% macro get_geo_columns() %}

{% set columns = [
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "value", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}