{{ config(enabled=var('ad_reporting__linkedin_ads_enabled', True)) }}

{{
    fivetran_utils.union_data(
        table_identifier='campaign_history', 
        database_variable='linkedin_database', 
        schema_variable='linkedin_schema', 
        default_database=target.database,
        default_schema='linkedin',
        default_variable='campaign_history',
        union_schema_variable='linkedin_ads_union_schemas',
        union_database_variable='linkedin_ads_union_databases'
    )
}}