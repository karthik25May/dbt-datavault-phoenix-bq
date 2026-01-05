{{ config(
    materialized='incremental'
) }}

{{ automate_dv.hub(
    source_model = 'v_stg_sales',
    src_nk = 'VENDOR_NUMBER',
    src_pk = 'VENDOR_HK',
    src_ldts = 'LOAD_DATETIME',
    src_source = 'RECORD_SOURCE'
) }}