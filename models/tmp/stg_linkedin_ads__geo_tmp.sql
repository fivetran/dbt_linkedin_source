{{ config(enabled=fivetran_utils.enabled_vars(['ad_reporting__linkedin_ads_enabled','linkedin_ads__using_geo'])) }}

{{
    fivetran_utils.union_data(
        table_identifier='geo', 
        database_variable='linkedin_ads_database', 
        schema_variable='linkedin_ads_schema', 
        default_database=target.database,
        default_schema='linkedin_ads',
        default_variable='geo',
        union_schema_variable='linkedin_ads_union_schemas',
        union_database_variable='linkedin_ads_union_databases'
    )
}}