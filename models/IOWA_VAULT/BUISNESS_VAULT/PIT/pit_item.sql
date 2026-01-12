{{ config(materialized='pit_incremental') }}

{%- set yaml_metadata -%}
source_model: 'hub_items'
src_pk: 'ITEM_HK'
as_of_dates_table: 'as_of_date'
satellites: 
  satellite_items:
    pk:
      PK: 'ITEM_HK'
    ldts:
      LDTS: 'SALES_DATE'
stage_tables:
    v_stg_sales: 'SALES_DATE'
src_ldts: 'SALES_DATE'
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.pit(
    source_model=metadata_dict['source_model'],
    src_pk=metadata_dict['src_pk'],
    as_of_dates_table=metadata_dict['as_of_dates_table'],
    satellites=metadata_dict['satellites'],
    stage_tables_ldts=metadata_dict['stage_tables_ldts'],
    src_ldts=metadata_dict['src_ldts']
) }}