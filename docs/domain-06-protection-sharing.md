# Domain 06 - Data Protection and Data Sharing

## Objective
This phase demonstrates core Snowflake protection features through practical implementation and clear documentation.

## Features implemented

### 1. Time Travel recovery demo
A dedicated table, `TT_DEMO_SALES_PROTECTION`, was created from `FACT_SALES`.

A controlled delete operation was performed, then the missing rows were restored using Time Travel with a statement-based historical reference.

This demonstrates how Snowflake can recover data after accidental modification or deletion.

### 2. Table clone
`FACT_SALES_CLONE` was created as a zero-copy clone of `FACT_SALES`.

This demonstrates how Snowflake supports rapid object duplication for experimentation and validation.

### 3. Schema clone
`CURATED_DEV_CLONE` was created as a clone of the `CURATED` schema.

This demonstrates a realistic development workflow where production-like objects can be copied into an isolated environment for testing.

### 4. Secure view
`SECURE_VW_ACTIVE_CUSTOMER_SALES` was created in the `ANALYTICS` schema.

This demonstrates a more controlled method of exposing analytical data to consumer roles.

## Validation performed
- row count checked before delete, after delete, and after recovery
- clone row counts compared with source tables
- cloned schema queried successfully
- secure view queried successfully with consumer access

## Sharing concepts documented
This project focuses on the practical features that are directly reproducible in a trial account:
- Time Travel
- cloning
- secure data exposure

Broader Snowflake sharing capabilities were reviewed conceptually as part of SnowPro Core study, including secure sharing patterns and governed data consumption. If a feature is account-dependent or not practical in a trial workflow, it should be documented rather than overstated as implemented.

## Key learning
Data protection in Snowflake is not only about backups. It also includes:
- historical recovery
- isolated testing through cloning
- controlled data exposure through secure objects