{% macro get_account_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "created_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "currency", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_int()},
    {"name": "last_modified_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "name", "datatype": dbt_utils.type_string()},
    {"name": "notified_on_campaign_optimization", "datatype": "boolean"},
    {"name": "notified_on_creative_approval", "datatype": "boolean"},
    {"name": "notified_on_creative_rejection", "datatype": "boolean"},
    {"name": "notified_on_end_of_campaign", "datatype": "boolean"},
    {"name": "reference", "datatype": dbt_utils.type_string()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "total_budget_amount", "datatype": dbt_utils.type_float()},
    {"name": "total_budget_currency_code", "datatype": dbt_utils.type_string()},
    {"name": "total_budget_ends_at", "datatype": dbt_utils.type_int()},
    {"name": "type", "datatype": dbt_utils.type_string()},
    {"name": "version_tag", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
