{% macro get_monthly_ad_analytics_by_member_region_columns() %}

{% set columns = [
    {"name": "campaign_id", "datatype": dbt.type_int()},
    {"name": "month", "datatype": dbt.type_string(), "alias": "date_month"},
    {"name": "clicks", "datatype": dbt.type_int()},
    {"name": "member_region", "datatype": dbt.type_int()},
    {"name": "impressions", "datatype": dbt.type_int()},
    {"name": "conversion_value_in_local_currency", "datatype": dbt.type_numeric()},
    {"name": "cost_in_local_currency", "datatype": dbt.type_numeric()},
    {"name": "cost_in_usd", "datatype": dbt.type_numeric()}
] %}

{{ fivetran_utils.add_pass_through_columns(columns, var('linkedin_ads__conversion_fields')) }}

{# Doing it this way in case users were bringing in conversion metrics via passthrough columns prior to us adding them by default #}
{{ linkedin_ads_add_pass_through_columns(base_columns=columns, pass_through_fields=var('linkedin_ads__monthly_ad_analytics_by_member_region_passthrough_metrics'), except_fields=(var('linkedin_ads__conversion_fields') + ['conversion_value_in_local_currency'])) }}

{{ return(columns) }}

{% endmacro %}