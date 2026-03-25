-- =========================================================
-- 07_performance_queries.sql
-- Purpose: Demonstrate caching, warehouse sizing, and monitoring
-- Project: snowpro-core-hands-on-lab
-- =========================================================

-- ---------------------------------------------------------
-- 1. Build a controlled benchmark table
-- ---------------------------------------------------------

use role etl_role;
use warehouse core_de_wh;
use database core_demo_db;
use schema curated;

create or replace table perf_sales_stress as
select 
    seq4() as synthetic_row_id,
    fs.sale_id,
    fs.customer_id,
    fs.product_id,
    fs.sale_timestamp,
    fs.sale_date,
    fs.channel,
    fs.payment_method,
    fs.quantity,
    fs.unit_price,
    fs.gross_amount,
    dc.city,
    dc.country,
    dp.category,
    dp.brand
from core_demo_db.curated.fact_sales fs
join core_demo_db.curated.dim_customers dc
    on fs.CUSTOMER_ID =dc.CUSTOMER_ID
join core_demo_db.curated.dim_products dp 
    on fs.PRODUCT_ID= dp.PRODUCT_ID
cross join table(generator(rowcount =>20000));

select count(*) as perf_sales_stress_row_count
from core_demo_db.curated.perf_sales_stress;


-- ---------------------------------------------------------
-- 2. Cache demo on XSMALL
-- ---------------------------------------------------------
use role analyst_role;
use warehouse core_de_wh;
use database core_demo_db;
use schema analytics;

alter session set use_cached_result = true;

alter session set query_tag = 'Phases_Cache_DEMO_RUN1'

select 
    sale_date,
    channel,
    category,
    count(*) as row_count,
    sum(quantity) as total_units,
    sum(gross_amount) as total_revenue
from core_demo_db.curated.perf_sales_stress
group by 
    sale_date,
    channel,
    category
order by 
    sale_date,
    channel,
    category;

alter session set query_tag = 'PHASES_CACHE_DEMO_RUN2'

select 
    sale_date,
    channel,
    category,
    count(*) as row_count,
    sum(quantity) as total_units,
    sum(gross_amount) as total_revenue
from core_demo_db.curated.perf_sales_stress
group by 
    sale_date,
    channel,
    category
order by 
    sale_date,
    channel,
    category;

-- ---------------------------------------------------------
-- 3. Warehouse size comparison without result cache
-- ---------------------------------------------------------
alter session set use_cached_result =false;

use warehouse core_de_wh;
alter session set query_tag = 'PHASE5_size compare_xsmall';

select 
    country,
    category,
    payment_method,
    count(*) as row_count,
    count(distinct customer_id) as distinct_customers,
    sum(quantity) as total_units,
    sum(gross_amount) as total_revenue,
from core_demo_db.curated.perf_sales_stress
group by 
    country,
    category,
    payment_method
order by
    country,
    category,
    payment_method;

USE WAREHOUSE CORE_DE_WH_SMALL;
ALTER SESSION SET QUERY_TAG = 'PHASE5_SIZE_COMPARE_SMALL';

select 
    country,
    category,
    payment_method,
    count(*) as row_count,
    count(distinct customer_id) as distinct_customers,
    sum(quantity) as total_units,
    sum(gross_amount) as total_revenue,
from core_demo_db.curated.perf_sales_stress
group by 
    country,
    category,
    payment_method
order by
    country,
    category,
    payment_method;

-- ---------------------------------------------------------
-- 4. Query history review
-- ---------------------------------------------------------

alter session set use_cached_result =true;
alter session unset query_tag;

select 
    query_tag,
    query_id,
    warehouse_name,
    warehouse_size,
    execution_status,
    total_elapsed_time,
    bytes_scanned,
    rows_produced,

    start_time
from table(information_schema.query_history_by_session(result_limit =>50))

order by start_time;

-- ---------------------------------------------------------
-- 5. Focused comparison summary
-- ---------------------------------------------------------
SELECT
    QUERY_TAG,
    WAREHOUSE_NAME,
    WAREHOUSE_SIZE,
    TOTAL_ELAPSED_TIME,
    BYTES_SCANNED
FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY_BY_SESSION(RESULT_LIMIT => 50))
WHERE QUERY_TAG IN (
    'PHASE5_CACHE_DEMO_RUN1',
    'PHASE5_CACHE_DEMO_RUN2',
    'PHASE5_SIZE_COMPARE_XSMALL',
    'PHASE5_SIZE_COMPARE_SMALL'
)
ORDER BY START_TIME;