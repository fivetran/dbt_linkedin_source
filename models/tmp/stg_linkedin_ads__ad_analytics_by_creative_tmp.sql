ADD source_relation WHERE NEEDED + CHECK JOINS AND WINDOW FUNCTIONS! (Delete this line when done.)

{{ config(enabled=var('ad_reporting__linkedin_ads_enabled', True)) }}

{{
    fivetran_utils.union_data(
        table_identifier='stg_linkedin_ads__ad_analytics_by_creative', 
        database_variable='linkedin_database', 
        schema_variable='linkedin_schema', 
        default_database=target.database,
        default_schema='linkedin',
        default_variable='stg_linkedin_ads__ad_analytics_by_creative_source',
        union_schema_variable='linkedin_union_schemas',
        union_database_variable='linkedin_union_databases'
    )
}}