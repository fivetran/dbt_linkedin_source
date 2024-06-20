{% macro get_ad_analytics_by_campaign_columns() %}

{% set columns = [
    {"name": "campaign_id", "datatype": dbt.type_int()},
    {"name": "clicks", "datatype": dbt.type_int()},
    {"name": "cost_in_local_currency", "datatype": dbt.type_numeric()},
    {"name": "cost_in_usd", "datatype": dbt.type_numeric()},
    {"name": "day", "datatype": dbt.type_timestamp()},
    {"name": "impressions", "datatype": dbt.type_int()}, 
    {"name": "conversion_value_in_local_currency", "datatype": dbt.type_numeric()}
] %}

{% set unique_passthrough = var('linkedin_ads__campaign_passthrough_metrics') %}

{%- for conversion in var('linkedin_ads__conversion_fields') %}
    {% set check = [] -%}

    {% for field in var('linkedin_ads__campaign_passthrough_metrics') %}
        {%- set field_name = field.alias|default(field.name)|lower %}
        {% if conversion|lower == field_name %}
            {%- do check.append(conversion) %}
        {% endif %}
    {% endfor %}

    {% if conversion|lower not in check %}
    {% do unique_passthrough.append({"name": conversion}) %}
    {% endif %}
    
{% endfor -%}

{{ fivetran_utils.add_pass_through_columns(columns, unique_passthrough) }}

{{ return(columns) }}

{% endmacro %}
