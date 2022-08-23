{{ config(enabled=var('ad_reporting__linkedin_ads_enabled', True)) }}

select *
from {{ var('account_history') }}