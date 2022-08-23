{% macro get_account_history_columns() %}

{% set columns = [
    {"name": "created_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "currency", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_int()},
    {"name": "last_modified_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "name", "datatype": dbt_utils.type_string()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "type", "datatype": dbt_utils.type_string()},
    {"name": "version_tag", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
