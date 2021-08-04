
{% macro nested() %}
    {% set query %}
        {% set inner = 'inner' %}
        select '{{ inner }}'
    {% endset %}

    {% do run_query(query) %}
{% endmacro %}

{% macro t(test) %}


    {% set query %}
        {{ nested() }}
        {% set testing = 'it worked' %}
        select '{{ testing }}';
    {% endset %}

    {% do run_query(query) %}
{% endmacro %}