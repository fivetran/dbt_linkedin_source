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

-- {# 
--     Reach and Frequency are not included in downstream models by default, though they are included in the staging model.
--     The below ensures that users can add Reach and Frequency to downstream models with the `facebook_ads__basic_ad_passthrough_metrics` variable
--     while avoiding duplicate column errors.
--  #}
{% set unique_passthrough = var('linkedin_ads__campaign_passthrough_metrics') %}
{% for field in var('linkedin_ads__conversion_fields') %}
    {% for passthrough_fields in unique_passthrough %}
        {% if field|lower not in passthrough_fields.name %}
            {% do unique_passthrough.append({"name": field, "datatype": dbt.type_int()}) %}
        {% endif %}
    {% endfor %}
{% endfor %}

{{ fivetran_utils.add_pass_through_columns(columns, unique_passthrough) }}


{{ return(columns) }}

{% endmacro %}
