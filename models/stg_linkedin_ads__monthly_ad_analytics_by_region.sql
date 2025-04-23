{{ config(enabled=var('ad_reporting__linkedin_ads_enabled', True) and var('linkedin_ads__using_monthly_ad_analytics_by_member_region', True)) }}


with base as (

    select * 
    from {{ ref('stg_linkedin_ads__monthly_ad_analytics_by_region_tmp') }}
),

macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_linkedin_ads__monthly_ad_analytics_by_region_tmp')),
                staging_columns=get_monthly_ad_analytics_by_member_region_columns()
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
        {{ linkedin_source.date_from_month_string('date_month') }} as date_month, --Renamed in macros/get_monthly_ad_analytics_by_member_region_columns to avoid reserved word error.
        campaign_id,
        member_region,
        impressions,
        {% if var('linkedin_ads__use_local_currency', false) %}
        cost_in_local_currency as cost,
        {% else %}
        cost_in_usd as cost,
        {% endif %}

        coalesce(cast(conversion_value_in_local_currency as {{ dbt.type_float() }}), 0) as conversion_value_in_local_currency

        {% for conversion in var('linkedin_ads__conversion_fields', []) %}
            , coalesce(cast({{ conversion }} as {{ dbt.type_bigint() }}), 0) as {{ conversion }}
        {% endfor %}

        {{ linkedin_ads_fill_pass_through_columns(pass_through_fields=var('linkedin_ads__monthly_ad_analytics_by_member_region_passthrough_metrics'), except=(var('linkedin_ads__conversion_fields') + ['conversion_value_in_local_currency'])) }}

    from macro
)

select *
from fields
