with base as (

    select *
    from {{ source('linkedin','creative_history') }}

), fields as (

    select
        id as creative_id,
        last_modified_time as last_modified_at,
        created_time as created_at,
        campaign_id,
        type as creative_type,
        cast(version_tag as INT64) as version_tag,
        status as creative_status,
        call_to_action_target,
        click_uri
    from base

), valid_dates as (

    select 
        *,
        case 
            when row_number() over (partition by creative_id order by version_tag) = 1 then created_at
            else last_modified_at
        end as valid_from,
        lead(last_modified_at) over (partition by creative_id order by version_tag) as valid_to
    from fields

), surrogate_key as (

    select 
        *,
        {{ dbt_utils.surrogate_key(['creative_id','version_tag']) }} as creative_version_id
    from valid_dates

)

select *
from surrogate_key