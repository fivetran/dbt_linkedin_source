{% macro get_ad_analytics_by_creative_columns() %}

{% set columns = [
    {"name": "clicks", "datatype": dbt.type_int()},
    {"name": "cost_in_local_currency", "datatype": dbt.type_numeric()},
    {"name": "cost_in_usd", "datatype": dbt.type_numeric()},
    {"name": "creative_id", "datatype": dbt.type_int()},
    {"name": "day", "datatype": dbt.type_timestamp()},
    {"name": "impressions", "datatype": dbt.type_int()},
    {"name": "conversion_value_in_local_currency", "datatype": dbt.type_numeric()}
] %}

{{ fivetran_utils.add_pass_through_columns(columns, var('linkedin_ads__conversion_fields')) }}

{# Doing it this way in case users were bringing in conversion metrics via passthrough columns prior to us adding them by default #}
{{ linkedin_ads_add_pass_through_columns(base_columns=columns, pass_through_fields=var('linkedin_ads__creative_passthrough_metrics'), except_fields=(var('linkedin_ads__conversion_fields') + ['conversion_value_in_local_currency'])) }}

{{ return(columns) }}

{% endmacro %}
