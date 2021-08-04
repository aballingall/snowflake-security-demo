{% macro add_user(user_name) %}

    create or replace user {{ user_name }} 
        password = 'password'
        must_change_password = false
    ;

{% do log("Will add user " ~ user_name, info=True) %}

{% endmacro %}
