{% macro init_security_demo() %}

{% set default_password = 'password' %}
{% set default_warehouse = 'DV_PROTOTYPE_WH' %}
{% set database = 'SECURITY_DB' %}
{% set schema_rdv = 'RDV' %}
{% set schema_finance_mart = 'FINANCE_MART' %}
{% set schema_analyst = 'ANALYST' %}

{% set sql %}

    -- ENVIRONMENT-SPECIFIC ADMIN ROLES ----------------------------------------
    -- We ALWAYS use USERADMIN to add these roles,
    -- then use the admin roles we create from this point onwards.
    use role USERADMIN;

    -- Roles to manage users and roles:
    create or replace role DEV_SECURITY_ADMIN;
    create or replace role DEV_SYSADMIN;

    -- Roles to (eventually) own database objects. Note that these roles are
    -- granted to SYSADMIN (which ensures ACCOUNT ADMINISTRATORS have complete
    -- control).
    grant role DEV_SYSADMIN to role SYSADMIN;

    -- Setup database
    use role SYSADMIN;

    create database if not exists DEV_SECURITY_DB;
    grant usage on database DEV_SECURITY_DB to role DEV_SYSADMIN;
    grant all privileges on future schemas in database DEV_SECURITY_DB to role DEV_SYSADMIN;

    grant create warehouse on ACCOUNT to role DEV_SYSADMIN;
    grant create database on ACCOUNT to role DEV_SYSADMIN;

    -- DATABASE AND SCHEMA CREATION --------------------------------------------
    -- We ALWAYS use the env-specific admin roles to create and own these
    -- objects.

    -- DEV Database & schemas
    use role DEV_SYSADMIN;

    {{ create_database_schemas(database, 'dev') }}
 

    -- ENVIRONMENT-SPECIFIC BUSINESS FUNCTION roles ----------------------------
    -- These always use the corresponding <ENV>_SECURITY_ADMIN roles to create

    use role DEV_SECURITY_ADMIN;
    create or replace role BF_DEV_DATA_ENGINEER;
    create or replace role BF_DEV_ANALYST;
    create or replace role BF_DEV_FINANCE;
    create or replace role BF_DEV_PLATFORM_LOAD;
    create or replace role BF_DEV_PLATFORM_TRANSFORM;

    -- CREATE USERS -------------------------------------------------------------------
    -- (Note - we wouldn't configure users with passwords normally - is just 
    -- for this test)

    -- A new god user
    {{ add_user('t_ann_account_admin') }}
    grant role ACCOUNTADMIN to user t_ann_account_admin;

    -- Bob can assign manage production roles and grants, but not access
    -- production objects
    -- {{ add_user('t_bob_role_admin_prod') }}
    -- grant role PROD_SECURITY_ADMIN to user t_ann_account_admin;

    -- Jim can assign manage dev roles and grants, but not access
    -- dev objects
    {{ add_user('t_jim_role_admin_dev') }}
    grant role DEV_SECURITY_ADMIN to user t_ann_account_admin;

    -- A new analyst user
    -- create or replace user dev_admin_jim 
    --     password = 'password' must_change_password = false
    --     default_role = ACCOUNTADMIN
    --     ;

    -- create or replace user analyst_ade 
    --     password = 'password' must_change_password = false
    --     default_role = ACCOUNTADMIN
    --     ;

    -- create or replace user engineer_sam 
    --     password = 'password' must_change_password = false
    --     default_role = ACCOUNTADMIN
    --     ;

    -- create or replace user public_pam 
    --     password = 'password' must_change_password = false
    --     default_role = ACCOUNTADMIN
    --     ;

-- grant role {{ user_role }} to user {{ user_name }};

{% endset %}

{% do run_query(sql) %}
{% do log("Security Demo Initialised", info=True) %}

{% endmacro %}