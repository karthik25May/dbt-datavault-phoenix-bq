{{ config(
    materialized='incremental',
    unique_key=['ITEM_HASHDIFF','EFFECTIVE_FROM']
) }}

{{ automate_dv.eff_sat(
    source_model='v_stg_sales',
    src_pk='ITEM_HK',
     -- Use load date as EFFECTIVE_FROM
    src_eff='LOAD_DATETIME',

    -- EFFECTIVE_TO will be automatically calculated based on the next record
    # No need to provide src_end_eff; framework will handle it

    src_hashdiff='ITEM_HASHDIFF',
     src_payload=[
        'ITEM_DESCRIPTION'
    ],
    src_ldts='LOAD_DATETIME',
    src_source='RECORD_SOURCE'
) }}