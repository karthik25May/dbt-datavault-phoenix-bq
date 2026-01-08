{{ config(
    materialized='incremental',
    unique_key='INVOICEITEM_HK'
) }}

{{ automate_dv.sat(
    source_model='v_stg_sales',
    src_pk='INVOICEITEM_HK',
    src_hashdiff='INVOICEITEM_HASHDIFF',
    src_eff='SALES_DATE',
     src_payload=[
        'volume_sold_gallons',
        'volume_sold_liters',
        'sale_dollars',
        'bottles_sold',
        'state_bottle_retail',
        'state_bottle_cost',
        'bottle_volume_ml',
        'pack'
    ],
    src_ldts='LOAD_DATETIME',
    src_source='RECORD_SOURCE'
) }}