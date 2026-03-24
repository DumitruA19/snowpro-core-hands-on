# Domain 05 - Data Transformations

## Objective
This phase builds the curated data layer and business-facing analytics views for the SnowPro Core hands-on project.

## Objects created

### Curated tables
- `DIM_CUSTOMERS`
- `DIM_PRODUCTS`
- `FACT_SALES`
- `FACT_CLICKSTREAM_EVENTS`

### Analytics views
- `VW_SALES_ENRICHED`
- `VW_DAILY_SALES_SUMMARY`
- `VW_CLICKSTREAM_ACTIVITY_SUMMARY`

## Transformation logic

### Customer data
- trimmed text values
- standardized email to lowercase
- standardized status to uppercase
- retained latest row per customer with `ROW_NUMBER()` and `QUALIFY`

### Product data
- standardized category formatting
- retained latest row per product

### Sales data
- derived `SALE_DATE`
- derived `GROSS_AMOUNT`
- standardized payment and channel values

### Clickstream JSON data
JSON payloads stored in `VARIANT` were parsed into relational columns using Snowflake path syntax and explicit casts:
- `EVENT_DATA:event_id::STRING`
- `EVENT_DATA:customer_id::INTEGER`
- `EVENT_DATA:event_ts::STRING`

## Why this phase is important
This phase demonstrates the progression from raw ingestion to reusable analytical structures. It shows how Snowflake supports both structured and semi-structured transformation patterns in the same platform.

## Validation performed
- counted rows in curated tables
- queried parsed clickstream events
- queried enriched sales view
- queried daily sales aggregation

## Design note
A small RBAC patch was applied to allow `ETL_ROLE` to create views in the `ANALYTICS` schema while preserving the separation between build roles and consumer roles.