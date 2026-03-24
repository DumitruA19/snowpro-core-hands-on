# Domain 01 - Snowflake Architecture and Core Objects

## Objective
This section documents the foundational Snowflake objects used in the project.

## Core objects implemented so far
- warehouse: `CORE_DE_WH`
- database: `CORE_DEMO_DB`
- schemas: `RAW`, `CURATED`, `ANALYTICS`
- file formats: `FF_CORE_CSV`, `FF_CORE_JSON`
- stages: `STG_CORE_STRUCTURED`, `STG_CORE_JSON`
- raw tables for structured and semi-structured ingestion

## Architecture pattern
The project uses:
- a dedicated compute warehouse
- layered schemas
- named internal stages for ingestion
- typed relational raw tables for CSV
- a `VARIANT` raw table for JSON events

## Why this matters
This demonstrates core Snowflake object modeling and the separation of compute, storage, and logical organization.