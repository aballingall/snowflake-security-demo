--RESET this demo
use role ACCOUNTADMIN;
drop warehouse if exists DEV_ANALYST_XS;
drop database if exists DEV_A_DB;
drop database if exists PROD_A_DB;

drop role if exists DEV_SECURITY_ADMIN;
drop role if exists DEV_SYSADMIN;
drop role if exists PROD_SECURITY_ADMIN;
drop role if exists PROD_SYSADMIN;

drop role if exists OA_DEV_A_RDV_WRITE;
drop role if exists OA_DEV_A_RDV_EXEC;
drop role if exists OA_DEV_A_RDV_OWN;

drop role if exists OA_DEV_A_SANDBOX_READ; 
drop role if exists OA_DEV_A_SANDBOX_WRITE;
drop role if exists OA_DEV_A_SANDBOX_EXEC;
drop role if exists OA_DEV_A_SANDBOX_OWN;

-- Business function roles:
drop role if exists BF_DEV_DATA_ENGINEER;
drop role if exists BF_DEV_ANALYST;
drop role if exists BF_DEV_MONITOR;
drop role if exists BF_DEV_DEVOPS;

show roles;
show grants;
show databases;
------------------------------------------


use role USERADMIN;

-- Roles dedicated to managing roles in each environment:
create or replace role DEV_SECURITY_ADMIN;
grant create role on ACCOUNT to role DEV_SECURITY_ADMIN; -- with grant option?
grant role DEV_SECURITY_ADMIN to role USERADMIN; -- Q for Snowflake: If I don't do this my user can't assume the role in this demo. Why is that?

-- Roles to (eventually) own database objects. Note that these roles are
-- granted to SYSADMIN (which ensures SYSADMIN role-holders have complete
-- control of all database objects).
create or replace role DEV_SYSADMIN;
grant role DEV_SYSADMIN to role SYSADMIN;

use role SYSADMIN;
grant create database on ACCOUNT to role DEV_SYSADMIN;
grant create warehouse on ACCOUNT to role DEV_SYSADMIN;

-- SYSADMIN grants the ENV SYSADMIN roles the ability to create (and therefore own) schemas, and also
-- allows them to define warehouses that will be used in the environment.
-- <ENV>_SYSADMIN creates a schema and warehouse(s) 

use role DEV_SYSADMIN;
create database if not exists DEV_A_DB;
use database DEV_A_DB;
create schema RDV with managed access;
create schema sandbox with managed access;
create warehouse if not exists DEV_ANALYST_XS with 
warehouse_size=xsmall 
auto_suspend=300
;


-- <ENV>_SECURITY_ADMIN Defines roles for the <ENV>
use role DEV_SECURITY_ADMIN;

-- Per-schema access roles:
create role if not exists OA_DEV_A_RDV_READ;  // read-only
create role if not exists OA_DEV_A_RDV_WRITE; // write-only
create role if not exists OA_DEV_A_RDV_EXEC;  // execute-only (needed for stored procs too)
create role if not exists OA_DEV_A_RDV_OWN;   // confers ownership (i.e. objects created with this role can subsequently be deleted)

create role if not exists OA_DEV_A_SANDBOX_READ;  // read-only
create role if not exists OA_DEV_A_SANDBOX_WRITE; // write-only
create role if not exists OA_DEV_A_SANDBOX_EXEC;  // execute-only (needed for stored procs too)
create role if not exists OA_DEV_A_SANDBOX_OWN;   // confers ownership (i.e. objects created with this role can subsequently be deleted)

-- Business function roles:
create role if not exists BF_DEV_DATA_ENGINEER;
create role if not exists BF_DEV_ANALYST;
create role if not exists BF_DEV_MONITOR;
create role if not exists BF_DEV_DEVOPS; -- CI/CD or orchestrated execution

-- Map Object access roles to business function roles
grant role OA_DEV_A_SANDBOX_OWN to role BF_DEV_ANALYST; -- Analysts own their sandbox (can drop tables)
grant role OA_DEV_A_RDV_READ to role BF_DEV_ANALYST;    -- Analysts can read the Raw Data Vault
grant role OA_DEV_A_RDV_EXEC to role BF_DEV_ANALYST; -- Needed to run stored procedures on RDV (AB: check)

-- Define devops access
grant role OA_DEV_A_RDV_OWN to role BF_DEV_DEVOPS; -- dbt owns the objects in 


use role DEV_SYSADMIN;

-- Define grants on Object Access Roles
grant usage on database DEV_A_DB to role OA_DEV_A_RDV_READ;
grant usage on all schemas in database    DEV_A_DB to role OA_DEV_A_RDV_READ;
-- note DEV_SYSADMIN does *not* have permission to grant access to FUTURE schemas. 
-- Only SECURITYADMIN and ACCOUNTADMIN can do this by default. We could give
-- DEV_SYSADMIN the global MANAGE GRANTS privilege, but that allows it to give
-- grants to database schemas it does not own. So for now, if we create additional
-- schemas, the grant on all tables must be applied again (e.g. via CI/CD) before
-- roles can start using it.
grant select on all tables in database     DEV_A_DB to role OA_DEV_A_RDV_READ;
grant select on future tables in schema DEV_A_DB.RDV to role OA_DEV_A_RDV_READ;
grant select on future tables in schema DEV_A_DB.SANDBOX to role OA_DEV_A_RDV_READ;


-- Assign business function roles to users:
--TODO

--------------------------------------------

