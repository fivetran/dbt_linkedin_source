{% macro get_ad_analytics_by_creative_columns() %}

{% set columns = [
    {"name": "clicks", "datatype": dbt.type_int()},
    {"name": "cost_in_local_currency", "datatype": dbt.type_numeric()},
    {"name": "cost_in_usd", "datatype": dbt.type_numeric()},
    {"name": "creative_id", "datatype": dbt.type_int()},
    {"name": "day", "datatype": dbt.type_timestamp()},
    {"name": "impressions", "datatype": dbt.type_int()},
    {"name": "external_website_conversions", "datatype": dbt.type_int()},
    {"name": "one_click_leads", "datatype": dbt.type_int()},
    {"name": "conversion_value_in_local_currency", "datatype": dbt.type_numeric()}
] %}

{{ fivetran_utils.add_pass_through_columns(columns, var('linkedin_ads__creative_passthrough_metrics')) }}

{{ return(columns) }}

{% endmacro %}
