{{ config(enabled=var('ad_reporting__linkedin_ads_enabled', True) and var('linkedin_ads__using_geo', True)) }}

with base as (

    select * 
    from {{ ref('stg_linkedin_ads__geo_tmp') }}
),

macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_linkedin_ads__geo_tmp')),
                staging_columns=get_geo_columns()
            )
        }}
    
        {{ fivetran_utils.source_relation(
            union_schema_variable='linkedin_ads_union_schemas', 
            union_database_variable='linkedin_ads_union_databases') 
        }}

    from base
),

fields as (
    
    select 
        source_relation,
        id as geo_id,
        value
    from macro
)

select *
from fields
