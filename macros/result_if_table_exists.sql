{%- macro result_if_table_exists(table_ref, result_statement, if_empty=1) -%}

{{ adapter.dispatch('result_if_table_exists', 'twitter_organic') (table_ref, result_statement, if_empty=1) }}

{%- endmacro -%}

{%- macro default__result_if_table_exists(table_ref, result_statement, if_empty=1) -%}
    {%- set is_empty_result = twitter_organic.is_table_empty(table_ref) -%} 
    {%- set is_empty = is_empty_result -%}
    {%- if is_empty == "True" %}
        {{ if_empty }}
    {%- else %}
        {{ partition_statement }}
    {%- endif %}
{%- endmacro %}