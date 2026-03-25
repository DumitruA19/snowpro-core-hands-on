-- =========================================================
-- 00c_phase5_performance_setup.sql
-- Purpose: Create comparison warehouse for performance testing
-- Project: snowpro-core-hands-on-lab
-- =========================================================

use role accountadmin;

create or replace warehouse core_de_wh_small
with
    warehouse_size = 'SMALL'
    auto_suspend = 60
    auto_resume = true
    initially_suspended = true
    comment = 'Small warehouse for performance testing';

show warehouses like 'core_de_wh%';