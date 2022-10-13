{% macro get_campaign_history_columns() %}

{% set columns = [
    {"name": "account_id", "datatype": dbt.type_int()},
    {"name": "audience_expansion_enabled", "datatype": "boolean"},
    {"name": "campaign_group_id", "datatype": dbt.type_int()},
    {"name": "cost_type", "datatype": dbt.type_string()},
    {"name": "created_time", "datatype": dbt.type_timestamp()},
    {"name": "creative_selection", "datatype": dbt.type_string()},
    {"name": "daily_budget_amount", "datatype": dbt.type_float()},
    {"name": "daily_budget_currency_code", "datatype": dbt.type_string()},
    {"name": "format", "datatype": dbt.type_string()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "last_modified_time", "datatype": dbt.type_timestamp()},
    {"name": "locale_country", "datatype": dbt.type_string()},
    {"name": "locale_language", "datatype": dbt.type_string()},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "objective_type", "datatype": dbt.type_string()},
    {"name": "offsite_delivery_enabled", "datatype": "boolean"},
    {"name": "optimization_target_type", "datatype": dbt.type_string()},
    {"name": "run_schedule_end", "datatype": dbt.type_timestamp()},
    {"name": "run_schedule_start", "datatype": dbt.type_timestamp()},
    {"name": "status", "datatype": dbt.type_string()},
    {"name": "type", "datatype": dbt.type_string()},
    {"name": "unit_cost_amount", "datatype": dbt.type_float()},
    {"name": "unit_cost_currency_code", "datatype": dbt.type_string()},
    {"name": "version_tag", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
