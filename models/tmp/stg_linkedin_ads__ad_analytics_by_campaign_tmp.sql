{{ config(enabled=var('ad_reporting__linkedin_ads_enabled', True)) }}

{{
    fivetran_utils.union_data(
        table_identifier='ad_analytics_by_campaign', 
        database_variable='linkedin_database', 
        schema_variable='linkedin_schema', 
        default_database=target.database,
        default_schema='linkedin',
        default_variable='ad_analytics_by_campaign',
        union_schema_variable='linkedin_ads_union_schemas',
        union_database_variable='linkedin_ads_union_databases'
    )
}}