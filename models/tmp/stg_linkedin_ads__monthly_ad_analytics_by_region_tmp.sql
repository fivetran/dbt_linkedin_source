{{ config(enabled=fivetran_utils.enabled_vars(['ad_reporting__linkedin_ads_enabled','linkedin_ads__using_monthly_ad_analytics_by_member_region'])) }}

{{
    fivetran_utils.union_data(
        table_identifier='monthly_ad_analytics_by_member_region', 
        database_variable='linkedin_ads_database', 
        schema_variable='linkedin_ads_schema', 
        default_database=target.database,
        default_schema='linkedin_ads',
        default_variable='monthly_ad_analytics_by_member_region',
        union_schema_variable='linkedin_ads_union_schemas',
        union_database_variable='linkedin_ads_union_databases'
    )
}}