{{ config(enabled=var('ad_reporting__linkedin_ads_enabled', True)) }}

select * 
from {{ var('ad_analytics_by_campaign') }}