with base as (

    select *
    from {{ ref('stg_linkedin__ad_analytics_by_creative_tmp') }}

), macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_linkedin__ad_analytics_by_creative_tmp')),
                staging_columns=get_ad_analytics_by_creative_columns()
            )
        }}
    from base

), fields as (

    select
        creative_id,
        day as date_day,
        clicks, 
        impressions,
        {% if var('linkedin__use_local_currency') %}
        cost_in_local_currency as cost
        {% else %}
        cost_in_usd as cost
        {% endif %}

        {% if var('linkedin__passthrough_metrics') %}
        , {{ var('linkedin__passthrough_metrics' )  | join(', ') }}
        {% endif %}

    from macro

), surrogate_key as (

    select
        *,
        {{ dbt_utils.surrogate_key(['date_day','creative_id']) }} as daily_creative_id
    from fields

)

select *
from surrogate_key
