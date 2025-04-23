{% macro date_from_month_string(month_str) %}
    {{ return(adapter.dispatch('date_from_month_string', 'linkedin_source')(month_str)) }}
{% endmacro %}

{% macro default__date_from_month_string(month_str) %}
    to_date(
        split_part({{ month_str }}, '-', 1) || '-' || lpad(split_part({{ month_str }}, '-', 2), 2, '0') || '-01',
        'YYYY-MM-DD'
    )
{% endmacro %}

{% macro bigquery__date_from_month_string(month_str) %}
    parse_date('%Y-%m-%d', concat(split({{ month_str }}, '-')[offset(0)], '-', lpad(split({{ month_str }}, '-')[offset(1)], 2, '0'), '-01'))
{% endmacro %}

{% macro databricks__date_from_month_string(month_str) %}
    to_date(
        concat(split({{ month_str }}, '-')[0], '-', lpad(split({{ month_str }}, '-')[1], 2, '0'), '-01')
    )
{% endmacro %}
