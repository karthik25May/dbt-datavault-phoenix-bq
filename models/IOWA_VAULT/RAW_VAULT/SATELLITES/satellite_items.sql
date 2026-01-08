{{ config(materialized='incremental') }}

{{ automate_dv.sat(
    source_model='v_stg_sales',
    src_pk='ITEM_HK',
    src_hashdiff='ITEM_HASHDIFF',
    src_eff='SALES_DATE',
    src_ldts='LOAD_DATETIME',
    src_source='RECORD_SOURCE',
    src_payload=[
        'ITEM_DESCRIPTION'
    ] 
) }}