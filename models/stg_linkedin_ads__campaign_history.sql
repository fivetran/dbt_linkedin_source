{{ config(enabled=var('ad_reporting__linkedin_ads_enabled', True)) }}

with base as (

    select *
    from {{ ref('stg_linkedin_ads__campaign_history_tmp') }}

), macro as (

    select 
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_linkedin_ads__campaign_history_tmp')),
                staging_columns=get_campaign_history_columns()
            )
        }}
    from base

), fields as (

    select 
        id as campaign_id,
        name as campaign_name,
        cast(version_tag as numeric) as version_tag,
        campaign_group_id,
        account_id,
        status,
        type,
        cost_type,
        creative_selection,
        daily_budget_amount,
        daily_budget_currency_code,
        unit_cost_amount,
        unit_cost_currency_code,
        format,
        locale_country,
        locale_language,
        objective_type,
        optimization_target_type,
        audience_expansion_enabled as is_audience_expansion_enabled,
        offsite_delivery_enabled as is_offsite_delivery_enabled,
        cast(run_schedule_start as {{ dbt.type_timestamp() }}) as run_schedule_start_at,
        cast(run_schedule_end as {{ dbt.type_timestamp() }}) as run_schedule_end_at,
        cast(last_modified_time as {{ dbt.type_timestamp() }}) as last_modified_at,
        cast(created_time as {{ dbt.type_timestamp() }}) as created_at,
        row_number() over (partition by id order by last_modified_time desc) = 1 as is_latest_version

    from macro

)

select *
from fields