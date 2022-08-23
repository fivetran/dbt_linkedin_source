{% macro get_campaign_history_columns() %}

{% set columns = [
    {"name": "account_id", "datatype": dbt_utils.type_int()},
    {"name": "audience_expansion_enabled", "datatype": "boolean"},
    {"name": "campaign_group_id", "datatype": dbt_utils.type_int()},
    {"name": "cost_type", "datatype": dbt_utils.type_string()},
    {"name": "created_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "creative_selection", "datatype": dbt_utils.type_string()},
    {"name": "daily_budget_amount", "datatype": dbt_utils.type_float()},
    {"name": "daily_budget_currency_code", "datatype": dbt_utils.type_string()},
    {"name": "format", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_int()},
    {"name": "last_modified_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "locale_country", "datatype": dbt_utils.type_string()},
    {"name": "locale_language", "datatype": dbt_utils.type_string()},
    {"name": "name", "datatype": dbt_utils.type_string()},
    {"name": "objective_type", "datatype": dbt_utils.type_string()},
    {"name": "offsite_delivery_enabled", "datatype": "boolean"},
    {"name": "optimization_target_type", "datatype": dbt_utils.type_string()},
    {"name": "run_schedule_end", "datatype": dbt_utils.type_timestamp()},
    {"name": "run_schedule_start", "datatype": dbt_utils.type_timestamp()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "type", "datatype": dbt_utils.type_string()},
    {"name": "unit_cost_amount", "datatype": dbt_utils.type_float()},
    {"name": "unit_cost_currency_code", "datatype": dbt_utils.type_string()},
    {"name": "version_tag", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
