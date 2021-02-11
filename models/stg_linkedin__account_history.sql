with base as (

    select *
    from {{ ref('stg_linkedin__account_history_tmp') }}

), macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_linkedin__account_history_tmp')),
                staging_columns=get_account_history_columns()
            )
        }}
    from base

), fields as (

    select 
        id as account_id,
        last_modified_time as last_modified_at,
        created_time as created_at,
        name as account_name,
        currency,
        cast(version_tag as numeric) as version_tag
    from macro

), valid_dates as (

    select 
        *,
        case 
            when row_number() over (partition by account_id order by version_tag) = 1 then created_at
            else last_modified_at
        end as valid_from,
        lead(last_modified_at) over (partition by account_id order by version_tag) as valid_to
    from fields

), surrogate_key as (

    select 
        *,
        {{ dbt_utils.surrogate_key(['account_id','version_tag']) }} as account_version_id
    from valid_dates

)

select *
from surrogate_key
