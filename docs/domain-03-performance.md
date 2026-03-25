# Domain 03 - Performance and Cost Optimization

## Objective
This phase demonstrates warehouse sizing, result caching, query history analysis, and cost-aware configuration in Snowflake.

## Objects used
- `CORE_DE_WH` (`XSMALL`)
- `CORE_DE_WH_SMALL` (`SMALL`)
- `CURATED.PERF_SALES_STRESS`

## Why a benchmark table was created
The base project datasets are intentionally small for a trial account. A controlled benchmark table was created to make query-history and warehouse-sizing observations more meaningful.

## Tests performed

### 1. Cache demonstration
The same aggregation query was executed twice on `CORE_DE_WH` with `USE_CACHED_RESULT = TRUE`.

Expected observation:
- the repeated query should be faster
- query history should indicate higher cache usage on the second run

### 2. Warehouse size comparison
The same aggregation query was executed:
- once on `CORE_DE_WH` (`XSMALL`)
- once on `CORE_DE_WH_SMALL` (`SMALL`)

`USE_CACHED_RESULT = FALSE` was set so the comparison would not be hidden by persisted results.

## Metrics reviewed
- `TOTAL_ELAPSED_TIME`
- `BYTES_SCANNED`
- `ROWS_PRODUCED`
- `PERCENTAGE_SCANNED_FROM_CACHE`
- `WAREHOUSE_NAME`
- `WAREHOUSE_SIZE`

## Cost-control choices
Both warehouses were configured with:
- `AUTO_SUSPEND = 60`
- `AUTO_RESUME = TRUE`
- `INITIALLY_SUSPENDED = TRUE`

These settings support a cost-conscious lab environment.

## Query Profile evidence
Screenshots from Snowsight Query Profile were saved in `docs/screenshots/` to document how queries executed.

## Key learning
This phase shows that Snowflake performance analysis is not just about runtime. It also includes:
- correct warehouse sizing
- cache awareness
- query-history monitoring
- evidence-based interpretation