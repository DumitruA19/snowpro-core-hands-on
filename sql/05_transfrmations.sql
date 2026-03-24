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
