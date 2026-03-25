# SnowPro Core Hands-On Lab

## Overview
This project is a practical Snowflake portfolio lab designed to reinforce all SnowPro Core certification domains through hands-on implementation.

## Business Scenario
A fictional retail company wants to centralize structured and semi-structured data in Snowflake for ingestion, transformation, analytics, and governed access.

The project includes:
- customer data
- product data
- sales transactions
- clickstream JSON events

## Project Goals
- review SnowPro Core topics through implementation
- build a professional GitHub portfolio project
- demonstrate architecture, security, loading, transformations, optimization, and protection features in Snowflake

## Initial Architecture
- Warehouse: `CORE_DE_WH`
- Database: `CORE_DEMO_DB`
- Schemas:
  - `RAW`
  - `CURATED`
  - `ANALYTICS`

## Execution Order
1. Environment setup
2. Roles and grants
3. Tables, stages, and file formats
4. Structured and semi-structured data loading
5. Transformations
6. Performance and cost review
7. Time Travel, cloning, and sharing notes

## Status
Phase 1 in progress: foundation setup

## Performance and Cost Review
The project includes a dedicated performance phase that demonstrates:
- warehouse sizing comparison (`XSMALL` vs `SMALL`)
- result-cache behavior on repeated queries
- query-history analysis using Snowflake metadata
- cost-conscious warehouse configuration with auto-suspend and auto-resume

A synthetic benchmark table was created from the curated layer to make performance observations more visible in a trial environment.