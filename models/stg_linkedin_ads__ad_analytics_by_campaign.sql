{{ config(enabled=var('ad_reporting__linkedin_ads_enabled', True)) }}

with base as (

    select * 
    from {{ ref('stg_linkedin_ads__ad_analytics_by_campaign_tmp') }}
),

macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_linkedin_ads__ad_analytics_by_campaign_tmp')),
                staging_columns=get_ad_analytics_by_campaign_columns()
            )
        }}
    
        {{ fivetran_utils.source_relation(
            union_schema_variable='linkedin_ads_union_schemas', 
            union_database_variable='linkedin_ads_union_databases') 
        }}

    from base
),

fields as (
    
    select 
        source_relation,
        {{ dbt.date_trunc('day', 'day') }} as date_day,
        campaign_id,
        clicks,
        impressions,
        {% if var('linkedin_ads__use_local_currency', false) %}
        cost_in_local_currency as cost
        {% else %}
        cost_in_usd as cost
        {% endif %}


 
        {%- set check = [] %}
        {%- for field in var('linkedin_ads__campaign_passthrough_metrics') -%}
            {%- set field_name = field.alias|default(field.name)|lower %}
            {% if field_name in var('linkedin_ads__conversion_fields') %}
                {% do check.append(field_name) %}
            {% endif %}
            {{ log(field_name, info=True) }}
        {%- endfor %}

        {{ log(check, info=True) }}

        {%- for metric in var('linkedin_ads__conversion_fields') -%}
            {% if metric not in check %}
            {{ log(metric, info=True) }}
                , {{ metric }}
            {% endif %}
        {%- endfor %}

        {# 
            Adapted from fivetran_utils.fill_pass_through_columns() macro. 
            Ensures that downstream summations work if a connector schema is missing one of your `linkedin_ads__conversion_passthrough_metrics`
        #}
        {% if var('linkedin_ads__campaign_passthrough_metrics') %}
            {% for field in var('linkedin_ads__campaign_passthrough_metrics') %}
                {% if field.transform_sql %}
                    , coalesce(cast({{ field.transform_sql }} as {{ dbt.type_float() }}), 0) as {{ field.alias if field.alias else field.name }}
                {% else %}
                    , coalesce(cast({{ field.alias if field.alias else field.name }} as {{ dbt.type_float() }}), 0) as {{ field.alias if field.alias else field.name }}
                {% endif %}
            {% endfor %}
        {% endif %}

        -- {{ fivetran_utils.fill_pass_through_columns('linkedin_ads__campaign_passthrough_metrics') }}

    from macro
)

select *
from fields
