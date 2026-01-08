{{ config(
    materialized='incremental',
    unique_key='INVOICEITEM_HK'
) }}

{{ automate_dv.link(
    source_model='v_stg_sales',
    src_pk='INVOICEITEM_HK',
    src_fk=['INVOICEITEM_HK','STORE_HK','ITEM_HK'],
    src_ldts='LOAD_DATETIME',
    src_source='RECORD_SOURCE'
) }}
