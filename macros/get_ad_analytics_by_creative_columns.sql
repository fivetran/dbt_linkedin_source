{% macro get_ad_analytics_by_creative_columns() %}

{% set columns = [
    {"name": "clicks", "datatype": dbt_utils.type_int()},
    {"name": "cost_in_local_currency", "datatype": dbt_utils.type_numeric()},
    {"name": "cost_in_usd", "datatype": dbt_utils.type_numeric()},
    {"name": "creative_id", "datatype": dbt_utils.type_int()},
    {"name": "day", "datatype": dbt_utils.type_timestamp()},
    {"name": "impressions", "datatype": dbt_utils.type_int()}
] %}

{{ fivetran_utils.add_pass_through_columns(columns, var('linkedin_ads__creative_passthrough_metrics')) }}

{{ return(columns) }}

{% endmacro %}
