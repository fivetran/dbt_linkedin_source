{% macro get_creative_history_columns() %}

{% set columns = [
    {"name": "campaign_id", "datatype": dbt.type_int()},
    {"name": "click_uri", "datatype": dbt.type_string()},
    {"name": "created_time", "datatype": dbt.type_timestamp()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "last_modified_time", "datatype": dbt.type_timestamp()},
    {"name": "last_modified_at", "datatype": dbt.type_timestamp()},
    {"name": "intended_status", "datatype": dbt.type_string()},
    {"name": "status", "datatype": dbt.type_string()},
] %}

{{ return(columns) }}

{% endmacro %}
