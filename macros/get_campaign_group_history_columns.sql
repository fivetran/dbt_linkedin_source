{% macro get_campaign_group_history_columns() %}

{% set columns = [
    {"name": "account_id", "datatype": dbt.type_int()},
    {"name": "backfilled", "datatype": "boolean"},
    {"name": "created_time", "datatype": dbt.type_timestamp()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "last_modified_time", "datatype": dbt.type_timestamp()},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "run_schedule_end", "datatype": dbt.type_timestamp()},
    {"name": "run_schedule_start", "datatype": dbt.type_timestamp()},
    {"name": "status", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
