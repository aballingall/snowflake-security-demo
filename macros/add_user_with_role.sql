{% macro add_user_with_role(user_name, password, user_role) %}

    create or replace user {{ user_name }} 
        password = '{{ password }}'
        must_change_password = false
        default_role = {{ user_role }}
    ;

    grant role {{ user_role }} to user {{ user_name }};
{% do log("Will add user " ~ user_name ~ " with role " ~ user_role, info=True) %}

{% endmacro %}
