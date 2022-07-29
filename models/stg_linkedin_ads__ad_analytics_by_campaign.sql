
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
    from base
),

fields as (
    
    select 
        cast(day as {{ dbt_utils.type_timestamp() }}) as date_day,
        campaign_id,
        clicks,
        impressions,
        {% if var('linkedin_ads__use_local_currency', false) %}
        cost_in_local_currency as cost
        {% else %}
        cost_in_usd as cost
        {% endif %}

        {{ fivetran_utils.fill_pass_through_columns('linkedin_ads__passthrough_metrics') }}

    from macro
),

final as (

    select 
        *,
        {{ dbt_utils.surrogate_key(['date_day','campaign_id']) }} as daily_campaign_id
    from fields
)

select *
from final
