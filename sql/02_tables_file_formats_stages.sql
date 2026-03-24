-- =========================================================
-- 02_tables_file_formats_stages.sql
-- Purpose: Create raw tables, file formats, and internal stages
-- Project: snowpro-core-hands-on-lab
-- =========================================================

use role etl_role;
use warehouse core_de_wh;
use database core_demo_db;
use schema core_demo_db.raw;

-- ---------------------------------------------------------
-- 1. Structured raw tables
-- ---------------------------------------------------------
create or replace table customers_raw(
    customerd_id integer,
    first_name string,
    last_name string,
    email string,
    city string,
    country string,
    signup_date date,
    status string,
    load_ts timestamp_ntz default current_timestamp()
)
comment = 'Raw customer data loaded from csv source files';

create or replace table products_raw(
    product_id integer,
    product_name string,
    category string,
    unit_price number(10,2),
    is_active boolean,
    load_ts timestamp_ntz default current_timestamp()
)
comment = 'Raw product data loaded from csv source files';

create or replace table sales_raw(
    sale_id integer,
    customer_id integer,
    product_id integer,
    sale_timestamp timestamp_ntz,
    quantity integer,
    unit_price number(10,2),
    payment_method string,
    channel string,
    load_ts timestamp_ntz default current_timestamp()
)
comment = 'Raw sales transaction data loaded from csv source files';

-- ---------------------------------------------------------
-- 2. Semi-structured raw table
-- ---------------------------------------------------------
create or replace table clickstream_raw(
    event_data variant,
    src_file_name string,
    load_ts timestamp_ntz default current_timestamp()
)
comment = 'Raw clickstream JSON events loaded into variant';

-- ---------------------------------------------------------
-- 3. Reusable file formats
-- ---------------------------------------------------------
create or replace file format ff_core_csv
    type = csv 
    skip_header = 1
    field_delimiter = ','
    field_optionally_enclosed_by= '"'
    trim_space = TRUE
    empty_field_as_null =TRUE
    null_if=('NULL', 'NULL', '');

create or replace file format ff_core_json
type = json
compression = auto;

-- ---------------------------------------------------------
-- 4. Named internal stages
-- ---------------------------------------------------------
create or replace stage stg_core_structured
    file_format = ff_core_csv
    comment = 'Internal stage for structured csv source files';

create or replace stage stg_core_json
    file_format = ff_core_json
    comment ='Internal stage for JSON source files';

-- ---------------------------------------------------------
-- 5. Validation
-- ---------------------------------------------------------
show tables in schema core_demo_db.raw;
show file formats in schema core_demo_db.raw;
show stages in schema core_demo_db.raw;

desc table customers_raw;
desc table clickstream_raw;
desc stage sig_core_structured;
desc file format FF_CORE_CSV;

list @stg_core_structured;
list @stg_core_json;