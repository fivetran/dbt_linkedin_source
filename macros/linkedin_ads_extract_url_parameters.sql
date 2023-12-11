{% macro linkedin_ads_extract_url_parameter(field, url_parameter) -%}

{{ adapter.dispatch('linkedin_ads_extract_url_parameter', 'linkedin_source') (field, url_parameter) }}

{% endmacro %}


{% macro default__linkedin_ads_extract_url_parameter(field, url_parameter) -%}

{{ dbt_utils.get_url_parameter(field, url_parameter) }}

{%- endmacro %}


{% macro spark__linkedin_ads_extract_url_parameter(field, url_parameter) -%}

{%- set formatted_url_parameter = "'" + url_parameter + "=([^&]+)'" -%}
nullif(regexp_extract({{ field }}, {{ formatted_url_parameter }}, 1), '')

{%- endmacro %}