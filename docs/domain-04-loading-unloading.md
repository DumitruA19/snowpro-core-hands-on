# Domain 04 - Data Loading and Unloading

## Objective
This phase implements repo-based ingestion into Snowflake using named internal stages and reusable file formats.

## Source files
The source datasets are stored directly in the repository under `data/raw/`:
- `customers.csv`
- `products.csv`
- `sales.csv`
- `clickstream.json`

## Objects created
### Raw tables
- `CUSTOMERS_RAW`
- `PRODUCTS_RAW`
- `SALES_RAW`
- `CLICKSTREAM_RAW`

### File formats
- `FF_CORE_CSV`
- `FF_CORE_JSON`

### Internal stages
- `STG_CORE_STRUCTURED`
- `STG_CORE_JSON`

## Design decisions
- structured CSV data is loaded into typed relational tables
- semi-structured JSON is loaded into a `VARIANT` column
- `LOAD_TS` supports auditability and troubleshooting
- `SRC_FILE_NAME` preserves basic lineage for JSON loads
- reusable file formats avoid duplicated parsing logic

## Validation performed
- stage contents checked with `LIST`
- raw tables populated using `COPY INTO`
- row counts verified after load
- JSON fields queried from the `VARIANT` payload

## Why this is a strong portfolio pattern
The project is reproducible because all source files are stored in GitHub and the loading workflow is documented end to end.