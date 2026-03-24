-- =========================================================
-- 03_load_structured_and_json.sql
-- Purpose: Load repo-hosted files from internal stages
-- Project: snowpro-core-hands-on-lab
-- =========================================================

use role etl_role;
use warehouse core_de_wh;
use database core_demo_db;
use schema raw;

-- ---------------------------------------------------------
-- 1. Load structured CSV files
-- ---------------------------------------------------------
copy into customers_raw
(
    CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME,
    EMAIL,
    CITY,
    COUNTRY,
    SIGNUP_DATE,
    STATUS
)
from @stg_core_structured/customers.csv
file_format = (format_name=ff_core_csv)
on_error = 'ABORT_STATEMENT';


copy into products_raw
(
    product_id,
    product_name,
    category,
    brand,
    unit_price,
    is_active
)
from @stg_core_structured/products.csv
file_format = (format_name = ff_core_csv)
on_error = 'ABORT_STATEMENT';

copy into sales_raw
(
    sale_id,
    customer_id,
    product_id,
    sale_timestamp,
    quantity,
    unit_price,
    payment_method,
    channel
)
from @stg_core_structured/sales.csv
file_format = ( format_name = ff_core_csv)
on_error = 'ABORT_STATEMENT';

-- ---------------------------------------------------------
-- 2. Load JSON file into VARIANT table
-- ---------------------------------------------------------
copy into clickstream_raw(event_data, src_file_name)
from(
    select 
        $1,
        metadata$filename
    from @stg_core_json/clickstream.json
)
file_format = (format_name = ff_core_json)
ON_ERROR = 'ABORT_STATEMENT';


-- ---------------------------------------------------------
-- 3. Validation queries
-- ---------------------------------------------------------
select 'customers_raw' as table_name, count(*) as row_count from customers_raw
union all
select 'products_raw' as table_name, count(*) as row_count from products_raw
union all 
select 'sales_raw' as table_name, count(*) as row_count from sales_raw
union all
select 'clickstream_raw' as table_name, count(*) as row_count from clickstream_raw;

select *from customers_raw order by customer_id;
select *from products_raw order by product_id;
select *from sales_raw order by sale_id;

select 
    event_data: event_id::string as event_id,
    event_data: customer_id::integer as customer_is,
    event_data: event_type::string as event_type,
    event_data: event_ts::string as event_ts,
    event_data: device::string as device,
    src_file_name
from clickstream_raw
order by event_id;


SELECT CURRENT_ROLE(), CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();