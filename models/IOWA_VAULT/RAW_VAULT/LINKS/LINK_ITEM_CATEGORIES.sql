{{ config(
    materialized='incremental',
    unique_key='ITEM_CATEGORY_HK'
) }}

{{ automate_dv.link(
    source_model='v_stg_sales',
    src_pk='ITEM_CATEGORY_HK',
    src_fk=['ITEM_HK','CATEGORY_HK'],
    src_ldts='LOAD_DATETIME',
    src_source='RECORD_SOURCE'
) }}
