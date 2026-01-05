{{ config(
    materialized='incremental'
) }}

{# Define the name as a standalone string variable first #}
{%- set source_str = 'v_stg_sales' -%}

{{ automate_dv.hub(
    source_model=source_str,
    src_pk='CATEGORY_HK',
    src_nk='CATEGORY',
    src_ldts='LOAD_DATETIME',
    src_source='RECORD_SOURCE'
) }}