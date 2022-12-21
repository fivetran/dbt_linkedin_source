{% macro get_account_history_columns() %}

{% set columns = [
    {"name": "created_time", "datatype": dbt.type_timestamp()},
    {"name": "currency", "datatype": dbt.type_string()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "last_modified_time", "datatype": dbt.type_timestamp()},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "status", "datatype": dbt.type_string()},
    {"name": "type", "datatype": dbt.type_string()},
    {"name": "version_tag", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
