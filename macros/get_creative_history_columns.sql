{% macro get_creative_history_columns() %}

{% set columns = [
    {"name": "call_to_action_label_type", "datatype": dbt_utils.type_string()},
    {"name": "campaign_id", "datatype": dbt_utils.type_int()},
    {"name": "click_uri", "datatype": dbt_utils.type_string()},
    {"name": "created_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "id", "datatype": dbt_utils.type_int()},
    {"name": "last_modified_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "type", "datatype": dbt_utils.type_string()},
    {"name": "version_tag", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
