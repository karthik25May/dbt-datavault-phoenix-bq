{{ config(
    materialized='incremental'
) }}

{{ automate_dv.sat(
    source_model='v_stg_sales',
    src_pk='STORE_HK',   
    src_hashdiff='STORE_HASHDIFF',
    src_payload=[
        'STORE_NAME',
        'ADDRESS',
        'CITY',
        'ZIP_CODE',
        'STORE_LOCATION',
        'COUNTY_NUMBER',
        'COUNTY'
    ], 
    src_eff='SALES_DATE', 
    src_ldts='LOAD_DATETIME',
    src_source='RECORD_SOURCE'
) }}