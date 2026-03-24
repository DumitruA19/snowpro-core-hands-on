# Domain 02 - Account Access and Security

## Objective
This phase implements the RBAC foundation for the SnowPro Core hands-on project.

## Roles created
- `CORE_ADMIN`
- `ETL_ROLE`
- `ANALYST_ROLE`
- `READONLY_ROLE`

## Role responsibilities

### CORE_ADMIN
Project-level admin role used to manage the learning project.

### ETL_ROLE
Used for ingestion and transformation work in:
- `RAW`
- `CURATED`

Privileges include:
- warehouse usage
- database usage
- schema usage
- create table, stage, file format, and view where appropriate
- DML on raw and curated tables

### ANALYST_ROLE
Used for querying curated and analytics-ready data.

Privileges include:
- warehouse usage
- database usage
- schema usage on `CURATED` and `ANALYTICS`
- select on current and future tables/views

### READONLY_ROLE
Used for read-only access to business-facing analytics objects.

Privileges include:
- warehouse usage
- database usage
- schema usage on `ANALYTICS`
- select on current and future tables/views in `ANALYTICS`

## Role hierarchy

READONLY_ROLE -> ANALYST_ROLE -> CORE_ADMIN  
ETL_ROLE -> CORE_ADMIN

This design supports:
- least privilege
- separation of duties
- simplified administration through inheritance

## Why this is a good Snowflake design
This role model is simple, scalable, and easy to maintain. It clearly separates ingestion work from reporting consumption while still allowing a project admin role to inherit both capabilities.

## Validation performed
- switched roles successfully
- confirmed grants with `SHOW GRANTS`
- verified that read-only role cannot create tables

## Next step
After RBAC is established, the next phase will build tables, stages, and file formats so that the ETL role can begin loading data.