-- =========================================================
-- 08b_schema_clone_demo.sql
-- purpose: demonstrate schema cloning for dev/test isolation
-- project: snowpro-core-hands-on-lab
-- =========================================================

use role accountadmin;
use warehouse core_de_wh;
use database core_demo_db;

create or replace schema curated_dev_clone
clone core_demo_db.curated;

show schemas like 'curated_dev_clone' in database core_demo_db;

select count(*) as cloned_fact_sales_count
from core_demo_db.curated_dev_clone.fact_sales;

select count(*) as cloned_dim_customers_count
from core_demo_db.curated_dev_clone.dim_customers;
