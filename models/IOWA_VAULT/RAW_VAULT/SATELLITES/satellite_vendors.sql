{{ config(
    materialized='incremental',
    unique_key=['VENDOR_HK']
) }}

{{ automate_dv.sat(
    source_model='v_stg_sales',
    src_pk='VENDOR_HK',
    src_hashdiff='VENDOR_HASHDIFF',
    src_payload=[
        'VENDOR_NAME'
    ],
    src_eff='SALES_DATE',
    src_ldts='LOAD_DATETIME',
    src_source='RECORD_SOURCE'
) }}