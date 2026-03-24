-- =========================================================
-- 00_setup_warehouse_database_schema.sql
-- Purpose: Create the base compute and data containers
-- Project: snowpro-core-hands-on-lab
-- =========================================================

use role accountadmin;

-- --------------------------------------------------------
-- 1.Create warehouse
-- --------------------------------------------------------

create or replace warehouse CORE_DE_WH
with
    warehouse_size = 'XSMALL'
    auto_suspend = 60
    auto_resume = TRUE
    initially_suspended = TRUE
    comment = 'Main warehouse for the SnowPro Core Lab';

-- --------------------------------------------------------
-- 2.Create database 
-- --------------------------------------------------------
create or replace database CORE_DEMO_DB
comment ='Main database for SnowPro Core Lab';

-- --------------------------------------------------------
-- 3.Create schemas
-- --------------------------------------------------------
create or replace schema CORE_DEMO_DB.RAW
comment ='Raw ingestin layer for source files';

create or replace schema CORE_DEMO_DB.CURATED
comment = 'Cleaned and transformed data layer';

create or replace schema CORE_DEMO_DB.ANALYTICS
comment ='Reporting and analytics layer';

-- --------------------------------------------------------
-- 4.Validate objects
-- --------------------------------------------------------
show warehouses like 'CORE_DE_WH';
show databases like 'CORE_DEMO_DB';
show schemas in database CORE_DEMO_DB;

select current_account(), current_region(), current_role(), current_warehouse();