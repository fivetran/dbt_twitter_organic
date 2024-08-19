{% macro window_function_if_table_exists(table_ref, partition_statement, if_empty=1) %}

{{ adapter.dispatch('window_function_if_table_exists', 'twitter_organic') (table_ref, partition_statement, if_empty=1) }}

{%- endmacro %}

{% macro default__window_function_if_table_exists(table_ref, partition_statement, if_empty=1) %}
        {% set is_empty = is_table_empty(table_ref) %}  
        {% if is_empty %} 
            {{ if_empty }}
        {% else %}
            {{ partition_statement }}
        {% endif %}
{% endmacro %}

{% macro is_table_empty(table_name) %}

{{ adapter.dispatch('is_table_empty', 'twitter_organic') (table_name) }}

{%- endmacro %}

{% macro default__is_table_empty(table_name) %}
    {% if execute and flags.WHICH in ('run', 'build') %}
    {% set row_count_query %}
        select count(*) as row_count from {{ table_name }}
    {% endset %}
    {% set results = run_query(row_count_query) %}
    {% if results %}
        {% set row_count = results.columns[0][0] %}
        {% if row_count == 0 %}
            {{ return(true) }}
        {% endif %}
    {% endif %}
    {% endif %}
    {{ return(false) }}
{% endmacro %}