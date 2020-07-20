with base as (

    select *
    from {{ source('linkedin','campaign_group_history') }}

), fields as (

    select 
        id as campaign_group_id,
        last_modified_time as last_modified_at,
        account_id,
        created_time as created_at,
        name as campaign_group_name
    from base

), valid_dates as (

    select 
        *,
        case 
            when row_number() over (partition by campaign_group_id order by last_modified_at) = 1 then created_at
            else last_modified_at
        end as valid_from,
        lead(last_modified_at) over (partition by campaign_group_id order by last_modified_at) as valid_to
    from fields

), surrogate_key as (

    select 
        *,
        {{ dbt_utils.surrogate_key(['campaign_group_id','last_modified_at']) }} as campaign_group_version_id
    from valid_dates

)

select *
from surrogate_key