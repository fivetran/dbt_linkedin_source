{{ config(enabled=var('ad_reporting__linkedin_ads_enabled', True)) }}

with base as (

    select *
    from {{ ref('stg_linkedin_ads__account_history_tmp') }}

), macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_linkedin_ads__account_history_tmp')),
                staging_columns=get_account_history_columns()
            )
        }}
    from base

), fields as (

    select 
        id as account_id,
        name as account_name,
        currency,
        cast(version_tag as numeric) as version_tag,
        status,
        type,
        cast(last_modified_time as {{ dbt.type_timestamp() }}) as last_modified_at,
        cast(created_time as {{ dbt.type_timestamp() }}) as created_at,
        row_number() over (partition by id order by last_modified_time desc) = 1 as is_latest_version

    from macro

)

select *
from fields