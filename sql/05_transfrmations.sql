-- =========================================================
-- 05_transformations.sql
-- Purpose: Build curated layer and analytics views
-- Project: snowpro-core-hands-on-lab
-- =========================================================

use role etl_role;
use warehouse core_de_wh;
use database core_demo_db;

-- ---------------------------------------------------------
-- 1. Curated customer dimension
-- ---------------------------------------------------------
use schema curated;

create or replace table dim_customers as
select
    customer_id,
    trim(first_name) as first_name,
    trim(last_name) as last_name,
    trim(email) as email,
    initcap(trim(city)) as city,
    initcap(trim(country)) as country,
    signup_date,
    upper(trim(status)) as status,
    load_ts
from core_demo_db.raw.customers_raw
qualify row_number() over (
    partition by customer_id 
    order by load_ts desc
    ) = 1;


-- ---------------------------------------------------------
-- 2. Curated product dimension
-- ---------------------------------------------------------
create or replace table dim_products as
select
    product_id,
    trim(product_name) as product_name,
    initcap(trim(category)) as category,
    trim(brand) as brand,
    unit_price,
    is_active,
    load_ts
from core_demo_db.raw.products_raw
qualify row_number() over (
    partition by product_id 
    order by load_ts desc
    ) = 1;


-- ---------------------------------------------------------
-- 3. Curated sales fact
-- ---------------------------------------------------------
create or replace table fact_sales as
select
    sale_id,
    customer_id,
    product_id,
    sale_timestamp,
    TO_DATE(sale_timestamp) as sale_date,
    quantity,
    unit_price,
    quantity*unit_price as gross_amount,
    upper(trim(payment_method)) as payment_method,
    upper(trim(channel)) as channel,
    load_ts
from core_demo_db.raw.sales_raw
qualify row_number() over (
    partition by sale_id 
    order by load_ts desc
    ) = 1;

    
-- ---------------------------------------------------------
-- 4. Curated clickstream fact from VARIANT
-- ---------------------------------------------------------
create or replace table fact_clickstream_events as
select 
event_data:event_id::string as event_id,
event_data:customer_id::integer as customer_id,
event_data:event_type::string as event_type,
to_timestamp_ntZ(EVENT_DATA:EVENT_TS::STRING) as event_TS,
to_date(to_timestamp_ntZ(EVENT_DATA:EVENT_TS::STRING)) as event_date,
event_data:page::string as page_name,
event_data:device::string as device,
event_data:session_id::string as session_id,
event_data:product_id::INTEGER as product_id,
event_data:referrer::string as referrer,
src_file_name,
load_ts
from core_demo_db.raw.clickstream_raw
qualify row_number() over (
  partition by event_data:event_id::string
  order by load_ts desc
) = 1;

-- ---------------------------------------------------------
-- 5. Analytics views
-- ---------------------------------------------------------
use schema analytics;

create or replace view vw_sales_enriched as
select
    fs.sale_id,
    fs.sale_timestamp,
    fs.sale_date,
    fs.channel,
    fs.payment_method,
    fs.quantity,
    fs.unit_price,
    fs.gross_amount,
    dc.customer_id,
    dc.first_name,
    dc.last_name,
    dc.city,
    dc.country,
    dc.status as customer_status,
    dp.product_id,
    dp.product_name,
    dp.category,
    dp.brand,
    dp.is_active as product_is_active
from core_demo_db.curated.fact_sales fs
join core_demo_db.curated.dim_customers dc
    on fs.customer_id = dc.customer_id
join core_demo_db.curated.dim_products dp
    on fs.product_id = dp.product_id;

create or replace view vw_daily_sales_summary as
select
    sale_date,
    channel,
    payment_method,
    count(*)                      as order_count,
    sum(quantity)                 as total_units,
    sum(gross_amount)             as total_revenue
from core_demo_db.curated.fact_sales
group by
    sale_date,
    channel,
    payment_method;

create or replace view vw_clickstream_activity_summary as
select
    event_date,
    event_type,
    device,
    count(*)                      as event_count,
    count(distinct session_id)    as distinct_sessions,
    count(distinct customer_id)   as distinct_customers
from core_demo_db.curated.fact_clickstream_events
group by
    event_date,
    event_type,
    device;

-- ---------------------------------------------------------
-- 6. validation
-- ---------------------------------------------------------
select 'dim_customers' as object_name, count(*) as row_count
from core_demo_db.curated.dim_customers
union all
select 'dim_products', count(*)
from core_demo_db.curated.dim_products
union all
select 'fact_sales', count(*)
from core_demo_db.curated.fact_sales
union all
select 'fact_clickstream_events', count(*)
from core_demo_db.curated.fact_clickstream_events;

select * from core_demo_db.analytics.vw_sales_enriched order by sale_id;
select * from core_demo_db.analytics.vw_daily_sales_summary order by sale_date, channel, payment_method;
select * from core_demo_db.analytics.vw_clickstream_activity_summary order by event_date, event_type, device;
