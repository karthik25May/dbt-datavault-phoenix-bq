{{ config(
    materialized='incremental'
) }}

{{ automate_dv.sat(
    source_model='v_stg_sales',
    src_pk='CATEGORY_HK',
    src_hashdiff='CATEGORY_HASHDIFF',
    src_eff='SALES_DATE',
    src_payload=[
        'CATEGORY_NAME'
    ],
    src_ldts='LOAD_DATETIME',
    src_source='RECORD_SOURCE'
) }}