{{ config(enabled=var('ad_reporting__linkedin_ads_enabled', True)) }}

with base as (

    select *
    from {{ ref('stg_linkedin_ads__campaign_group_history_tmp') }}

), macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_linkedin_ads__campaign_group_history_tmp')),
                staging_columns=get_campaign_group_history_columns()
            )
        }}
    from base

), fields as (

    select 
        id as campaign_group_id,
        name as campaign_group_name,
        account_id,
        status,
        backfilled as is_backfilled,
        cast(run_schedule_start as {{ dbt.type_timestamp() }}) as run_schedule_start_at,
        cast(run_schedule_end as {{ dbt.type_timestamp() }}) as run_schedule_end_at,
        cast(last_modified_time as {{ dbt.type_timestamp() }}) as last_modified_at,
        cast(created_time as {{ dbt.type_timestamp() }}) as created_at,
        row_number() over (partition by id order by last_modified_time desc) = 1 as is_latest_version

    from macro

)

select *
from fields