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
    from base

), fields as (

    select
        id as creative_id,
        campaign_id,
        type,
        cast(version_tag as numeric) as version_tag,
        status,
        click_uri,
        call_to_action_label_type,
        cast(last_modified_time as {{ dbt_utils.type_timestamp() }}) as last_modified_at,
        cast(created_time as {{ dbt_utils.type_timestamp() }}) as created_at,
        row_number() over (partition by id order by last_modified_time desc) = 1 as is_latest_version

    from macro

), url_fields as (

    select 
        *,
        {{ dbt_utils.split_part('click_uri', "'?'", 1) }} as base_url,
        {{ dbt_utils.get_url_host('click_uri') }} as url_host,
        '/' || {{ dbt_utils.get_url_path('click_uri') }} as url_path,
        {{ dbt_utils.get_url_parameter('click_uri', 'utm_source') }} as utm_source,
        {{ dbt_utils.get_url_parameter('click_uri', 'utm_medium') }} as utm_medium,
        {{ dbt_utils.get_url_parameter('click_uri', 'utm_campaign') }} as utm_campaign,
        {{ dbt_utils.get_url_parameter('click_uri', 'utm_content') }} as utm_content,
        {{ dbt_utils.get_url_parameter('click_uri', 'utm_term') }} as utm_term
    
    from fields
)

select *
from url_fields

