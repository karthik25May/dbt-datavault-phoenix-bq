{{ config(materialized='view') }}

{%- set yaml_metadata -%}
source_model: "raw_sales"

derived_columns:
  RECORD_SOURCE: "'BQ_IOWA'"
  LOAD_DATETIME: "CURRENT_TIMESTAMP()"

hashed_columns:
  # -------------------------
  # HUB HASH KEYS
  # -------------------------
  VENDOR_HK:
    columns:
      - VENDOR_NUMBER

  ITEM_HK:
    columns:
      - ITEM_NUMBER

  CATEGORY_HK:
    columns:
      - CATEGORY

  STORE_HK:
    columns:
      - STORE_NUMBER

  INVOICEITEM_HK:
    columns:
      - INVOICE_AND_ITEM_NUMBER

  # -------------------------
  # LINK HASH KEYS
  # -------------------------
  ITEM_VENDOR_HK:
    columns:
      - ITEM_NUMBER
      - VENDOR_NUMBER

  ITEM_CATEGORY_HK:
    columns:
      - ITEM_NUMBER
      - CATEGORY

  INVOICEITEM_FK_HK:
    columns:
      - INVOICE_AND_ITEM_NUMBER
      - STORE_NUMBER
      - ITEM_NUMBER

  # -------------------------
  # HASHDIFF (Satellite)
  # -------------------------
  INVOICEITEM_HASHDIFF:
    is_hashdiff: true
    columns:
      - volume_sold_gallons
      - volume_sold_liters
      - sale_dollars
      - bottles_sold
      - state_bottle_retail
      - state_bottle_cost
      - bottle_volume_ml
      - pack
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(
    source_model = metadata_dict['source_model'],
    include_source_columns = true,
    derived_columns = metadata_dict['derived_columns'],
    hashed_columns = metadata_dict['hashed_columns']
) }}
