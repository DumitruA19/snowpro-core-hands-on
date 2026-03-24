-- =========================================================
-- 01b_phase4_analytics_grants.sql
-- Purpose: Allow ETL role to publish analytics views
-- Project: snowpro-core-hands-on-lab
-- =========================================================

USE ROLE ACCOUNTADMIN;

GRANT USAGE ON SCHEMA CORE_DEMO_DB.ANALYTICS TO ROLE ETL_ROLE;
GRANT CREATE VIEW ON SCHEMA CORE_DEMO_DB.ANALYTICS TO ROLE ETL_ROLE;

SHOW GRANTS TO ROLE ETL_ROLE;