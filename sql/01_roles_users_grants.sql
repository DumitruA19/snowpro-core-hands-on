-- =========================================================
-- 01_roles_users_grants.sql
-- Purpose: Create project roles and assign least-privilege grants
-- Project: snowpro-core-hands-on-lab
-- =========================================================
use role accountadmin;
-- --------------------------------------------------------
-- 1.Create custom roles
-- --------------------------------------------------------
create role if not exists CORE_ADMIN
comment ='Project administrator role for the SnowPro Core Lab';

create role if not exists ETL_ROLE
comment= 'Role for ingestion and transformation in RAW and CURATED';

create role if not exists ANALYST_ROLE
comment='Role for analysts querying CURATED and ANALYTICS';

create role if not exists READONLY_ROLE
comment ='Read-only for analytics consumption';

-- --------------------------------------------------------
-- 2.Create role hierarchy
-- --------------------------------------------------------
grant role READONLY_ROLE to role ANALYST_ROLE;
grant role ANALYST_ROLE to role CORE_ADMIN;
grant role ETL_ROLE to role CORE_ADMIN;

-- --------------------------------------------------------
-- 3.Grant project role to your user
-- --------------------------------------------------------
select current_user();

grant role CORE_ADMIN to user ANDREIDUMITRU;

-- --------------------------------------------------------
-- 4.Warehouse privileges
-- --------------------------------------------------------
grant usage, operate on warehouse core_de_wh to role core_admin;

grant usage on warehouse core_de_wh to role etl_role;
grant usage on warehouse core_de_wh to role analyst_role;
grant usage on warehouse core_de_wh to role readonly_role;

-- --------------------------------------------------------
-- 5.Database privileges
-- --------------------------------------------------------
grant usage on database core_demo_db to role core_admin;
grant usage on database core_demo_db to role etl_role;
grant usage on database core_demo_db to role analyst_role;
grant usage on database core_demo_db to role readonly_role;

-- --------------------------------------------------------
--6.Schema privileges
-- --------------------------------------------------------
--CORE_ADMIN
GRANT USAGE ON ALL SCHEMAS IN DATABASE CORE_DEMO_DB TO ROLE CORE_ADMIN;
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE CORE_DEMO_DB TO ROLE CORE_ADMIN;

--ETL_ROLE
GRANT USAGE ON SCHEMA CORE_DEMO_DB.RAW TO ROLE ETL_ROLE;
GRANT USAGE ON SCHEMA CORE_DEMO_DB.CURATED TO ROLE ETL_ROLE;

GRANT CREATE TABLE ON SCHEMA CORE_DEMO_DB.RAW TO ROLE ETL_ROLE;
GRANT CREATE STAGE ON SCHEMA CORE_DEMO_DB.RAW TO ROLE ETL_ROLE;
GRANT CREATE FILE FORMAT ON SCHEMA CORE_DEMO_DB.RAW TO ROLE ETL_ROLE;
GRANT CREATE VIEW ON SCHEMA CORE_DEMO_DB.RAW TO ROLE ETL_ROLE;

GRANT CREATE TABLE ON SCHEMA CORE_DEMO_DB.CURATED TO ROLE ETL_ROLE;
GRANT CREATE VIEW ON SCHEMA CORE_DEMO_DB.CURATED TO ROLE ETL_ROLE;

-- ANALYST_ROLE
GRANT USAGE ON SCHEMA CORE_DEMO_DB.CURATED TO ROLE ANALYST_ROLE;
GRANT USAGE ON SCHEMA CORE_DEMO_DB.ANALYTICS TO ROLE ANALYST_ROLE;

-- READONLY_ROLE
GRANT USAGE ON SCHEMA CORE_DEMO_DB.ANALYTICS TO ROLE READONLY_ROLE;


-- ---------------------------------------------------------
-- 7. Existing and future object privileges
-- ---------------------------------------------------------
-- ETL_ROLE: can work with tables in RAW and CURATED
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE
    ON ALL TABLES IN SCHEMA CORE_DEMO_DB.RAW TO ROLE ETL_ROLE;

GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE
    ON FUTURE TABLES IN SCHEMA CORE_DEMO_DB.RAW TO ROLE ETL_ROLE;

GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE
    ON ALL TABLES IN SCHEMA CORE_DEMO_DB.CURATED TO ROLE ETL_ROLE;

GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE
    ON FUTURE TABLES IN SCHEMA CORE_DEMO_DB.CURATED TO ROLE ETL_ROLE;

GRANT SELECT
    ON ALL VIEWS IN SCHEMA CORE_DEMO_DB.RAW TO ROLE ETL_ROLE;

GRANT SELECT
    ON FUTURE VIEWS IN SCHEMA CORE_DEMO_DB.RAW TO ROLE ETL_ROLE;

GRANT SELECT
    ON ALL VIEWS IN SCHEMA CORE_DEMO_DB.CURATED TO ROLE ETL_ROLE;

GRANT SELECT
    ON FUTURE VIEWS IN SCHEMA CORE_DEMO_DB.CURATED TO ROLE ETL_ROLE;

-- ANALYST_ROLE: query curated and analytics
GRANT SELECT
    ON ALL TABLES IN SCHEMA CORE_DEMO_DB.CURATED TO ROLE ANALYST_ROLE;

GRANT SELECT
    ON FUTURE TABLES IN SCHEMA CORE_DEMO_DB.CURATED TO ROLE ANALYST_ROLE;

GRANT SELECT
    ON ALL VIEWS IN SCHEMA CORE_DEMO_DB.CURATED TO ROLE ANALYST_ROLE;

GRANT SELECT
    ON FUTURE VIEWS IN SCHEMA CORE_DEMO_DB.CURATED TO ROLE ANALYST_ROLE;

GRANT SELECT
    ON ALL TABLES IN SCHEMA CORE_DEMO_DB.ANALYTICS TO ROLE ANALYST_ROLE;

GRANT SELECT
    ON FUTURE TABLES IN SCHEMA CORE_DEMO_DB.ANALYTICS TO ROLE ANALYST_ROLE;

GRANT SELECT
    ON ALL VIEWS IN SCHEMA CORE_DEMO_DB.ANALYTICS TO ROLE ANALYST_ROLE;

GRANT SELECT
    ON FUTURE VIEWS IN SCHEMA CORE_DEMO_DB.ANALYTICS TO ROLE ANALYST_ROLE;

-- READONLY_ROLE: query analytics only
GRANT SELECT
    ON ALL TABLES IN SCHEMA CORE_DEMO_DB.ANALYTICS TO ROLE READONLY_ROLE;

GRANT SELECT
    ON FUTURE TABLES IN SCHEMA CORE_DEMO_DB.ANALYTICS TO ROLE READONLY_ROLE;

GRANT SELECT
    ON ALL VIEWS IN SCHEMA CORE_DEMO_DB.ANALYTICS TO ROLE READONLY_ROLE;

GRANT SELECT
    ON FUTURE VIEWS IN SCHEMA CORE_DEMO_DB.ANALYTICS TO ROLE READONLY_ROLE;

-- ---------------------------------------------------------
-- 8. Validation
-- ---------------------------------------------------------
SHOW ROLES LIKE 'CORE%';
SHOW ROLES LIKE '%ROLE';

SHOW GRANTS TO ROLE CORE_ADMIN;
SHOW GRANTS TO ROLE ETL_ROLE;
SHOW GRANTS TO ROLE ANALYST_ROLE;
SHOW GRANTS TO ROLE READONLY_ROLE;