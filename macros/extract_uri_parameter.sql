{% macro extract_uri_parameter(field, uri_parameter) -%}
    {{ return(adapter.dispatch('extract_uri_parameter', 'linkedin_source')(field, uri_parameter)) }}
{% endmacro %}

{% macro default__extract_uri_parameter(field, uri_parameter) -%}
{{ dbt_utils.get_url_parameter(field, uri_parameter) }}
{%- endmacro %}

{% macro databricks__extract_uri_parameter(field, uri_parameter) -%}
{%- set formatted_uri_parameter = "'" + uri_parameter + "='" -%}
nullif(regexp_extract({{ field }}, concat({{ formatted_uri_parameter }}, '([^&]+)'), 1),'')
{%- endmacro %}