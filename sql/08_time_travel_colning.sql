-- =========================================================
-- 08_time_travel_cloning.sql
-- purpose: demonstrate time travel, cloning, and secure view
-- project: snowpro-core-hands-on-lab
-- =========================================================

-- ---------------------------------------------------------
-- 1. create a dedicated protection demo table
-- ---------------------------------------------------------
use role etl_role;
use warehouse core_de_wh;
use database core_demo_db;
use schema curated;

create or replace table tt_demo_sales_protection as
select *
from core_demo_db.curated.fact_sales;

select count(*) as before_change_count
from tt_demo_sales_protection;

-- capture statement ids manually in snowsight if you want stronger evidence.
-- you can also review them later in query history.

-- ---------------------------------------------------------
-- 2. simulate a mistake
-- ---------------------------------------------------------
delete from tt_demo_sales_protection
where sale_id in (1001, 1002);

select count(*) as after_delete_count
from tt_demo_sales_protection;

-- ---------------------------------------------------------
-- 3. recover data with time travel
-- ---------------------------------------------------------
insert into tt_demo_sales_protection
select *
from tt_demo_sales_protection
before (statement => last_query_id());

-- the last_query_id() above refers to the immediately previous statement.
-- if you want fully deterministic recovery, replace it later with the exact
-- delete statement id from query history.

select count(*) as after_recovery_count
from tt_demo_sales_protection;

select * 
from tt_demo_sales_protection
order by sale_id;

-- ---------------------------------------------------------
-- 4. table clone demo
-- ---------------------------------------------------------
create or replace table fact_sales_clone
clone core_demo_db.curated.fact_sales;

select count(*) as fact_sales_clone_count
from fact_sales_clone;

-- ---------------------------------------------------------
-- 5. secure view demo
-- ---------------------------------------------------------
use schema analytics;

create or replace secure view secure_vw_active_customer_sales as
select
    fs.sale_id,
    fs.sale_date,
    fs.channel,
    fs.payment_method,
    fs.gross_amount,
    dc.customer_id,
    dc.first_name,
    dc.last_name,
    dc.city,
    dc.country
from core_demo_db.curated.fact_sales fs
join core_demo_db.curated.dim_customers dc
    on fs.customer_id = dc.customer_id
where dc.status = 'active';

select *
from secure_vw_active_customer_sales
order by sale_id;

show views in schema core_demo_db.analytics;
