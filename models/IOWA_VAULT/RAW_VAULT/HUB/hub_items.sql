{{ config(
    materialized='incremental'
) }}

{{ automate_dv.hub(
    source_model = 'v_stg_sales',
    src_nk = 'ITEM_NUMBER',
    src_pk = 'ITEM_HK',
    src_ldts = 'LOAD_DATETIME',
    src_source = 'RECORD_SOURCE'
) }}