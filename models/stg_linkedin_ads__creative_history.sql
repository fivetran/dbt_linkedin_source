{{ config(enabled=var('ad_reporting__linkedin_ads_enabled', True)) }}

with base as (

    select *
    from {{ ref('stg_linkedin_ads__creative_history_tmp') }}

), macro as (

    select 
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_linkedin_ads__creative_history_tmp')),
                staging_columns=get_creative_history_columns()
            )
        }}
    
        {{ fivetran_utils.source_relation(
            union_schema_variable='linkedin_ads_union_schemas', 
            union_database_variable='linkedin_ads_union_databases') 
        }}

    from base

), fields as (

    select
        source_relation,
        id as creative_id,
        campaign_id,
        coalesce(status, intended_status) as status,
        coalesce(text_ad_landing_page, spotlight_landing_page, click_uri) as click_uri,
        cast(coalesce(last_modified_time, last_modified_at) as {{ dbt.type_timestamp() }}) as last_modified_at,
        cast(coalesce(created_time, created_at) as {{ dbt.type_timestamp() }}) as created_at,
        case when text_ad_landing_page is not null then 'text_ad'
            when spotlight_landing_page is not null then 'spotlight'
            else cast(null as {{ dbt.type_string() }})
        end as click_uri_type

    from macro

), url_fields as (

    select 
        *,
        row_number() over (partition by creative_id {{ ', source_relation' if (var('linkedin_ads_union_schemas', []) or var('linkedin_ads_union_databases', []) | length > 1) }} order by last_modified_at desc) = 1 as is_latest_version,
        {{ dbt.split_part('click_uri', "'?'", 1) }} as base_url,
        {{ dbt_utils.get_url_host('click_uri') }} as url_host,
        '/' || {{ dbt_utils.get_url_path('click_uri') }} as url_path,
        {{ linkedin_source.linkedin_ads_extract_url_parameter('click_uri', 'utm_source') }} as utm_source,
        {{ linkedin_source.linkedin_ads_extract_url_parameter('click_uri', 'utm_medium') }} as utm_medium,
        {{ linkedin_source.linkedin_ads_extract_url_parameter('click_uri', 'utm_campaign') }} as utm_campaign,
        {{ linkedin_source.linkedin_ads_extract_url_parameter('click_uri', 'utm_content') }} as utm_content,
        {{ linkedin_source.linkedin_ads_extract_url_parameter('click_uri', 'utm_term') }} as utm_term
    
    from fields
)

select *
from url_fields

