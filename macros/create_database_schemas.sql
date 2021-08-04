{% macro create_database_schemas(database, env) %}
   {% set db_name = (env ~ '_' ~ database) | upper %}

    create database if not exists {{ db_name }};
    use database {{ db_name }};
    create or replace transient schema {{ schema_rdv }} with managed access;
    create or replace transient schema {{ schema_finance_mart }} with managed access;
    create or replace transient schema {{ schema_analyst }} with managed access;  

{% endmacro %}