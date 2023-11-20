{% macro get_url_parameter(field, url_parameter) -%}
    {{ return(adapter.dispatch('get_url_parameter', 'dbt_utils')(field, url_parameter)) }}
{% endmacro %}

{% macro default__get_url_parameter(field, url_parameter) -%}

{%- set formatted_url_parameter = "'" + url_parameter + "='" -%}

{%- set split = dbt.split_part(dbt.split_part(field, formatted_url_parameter, 2), "'&'", 1) -%}

nullif({{ split }},'')

{%- endmacro %}


{% macro databricks__get_url_parameter(field, url_parameter) -%}

{%- set formatted_url_parameter = "'" + url_parameter + "='" -%}

case 
    when regexp_extract({{ field }}, concat({{ formatted_url_parameter }}, '([^&]+)'), 1) != ''
    then regexp_extract({{ field }}, concat({{ formatted_url_parameter }}, '([^&]+)'), 1)
    else null end

{%- endmacro %}