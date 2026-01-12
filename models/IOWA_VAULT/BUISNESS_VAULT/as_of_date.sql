{{ config(
    materialized='table'
) }}

 select distinct
        DATETIME(SALES_DATE) as as_of_date
    from {{ ref('satellite_invoices') }}
    UNION ALL
    SELECT DATETIME('2026-01-09 12:45:42')
    ORDER BY 1 ASC