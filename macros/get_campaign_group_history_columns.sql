{% macro get_campaign_group_history_columns() %}

{% set columns = [
    {"name": "account_id", "datatype": dbt_utils.type_int()},
    {"name": "backfilled", "datatype": "boolean"},
    {"name": "created_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "id", "datatype": dbt_utils.type_int()},
    {"name": "last_modified_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "name", "datatype": dbt_utils.type_string()},
    {"name": "run_schedule_end", "datatype": dbt_utils.type_timestamp()},
    {"name": "run_schedule_start", "datatype": dbt_utils.type_timestamp()},
    {"name": "status", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
