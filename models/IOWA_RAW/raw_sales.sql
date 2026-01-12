{{ config(
    materialized = 'incremental',
    incremental_strategy = 'merge',
    unique_key = 'invoice_and_item_number'
) }}
SELECT 
invoice_and_item_number,
date,
REPLACE(store_number,'.0','') as store_number,
store_name,
address,
city,
zip_code,
store_location,
county_number,
county,
REPLACE(category,'.0','') as category,
category_name,
REPLACE(vendor_number,'.0','') as vendor_number,
vendor_name,
REPLACE(item_number,'.0','') as item_number,
item_description,
pack,
bottle_volume_ml,
state_bottle_cost,
state_bottle_retail,
bottles_sold,
sale_dollars,
volume_sold_liters,
volume_sold_gallons
FROM `bigquery-public-data.iowa_liquor_sales.sales` 
{% if is_incremental() %}
WHERE DATE BETWEEN IFNULL((SELECT MAX(DATE)+1 FROM {{this}}),'2025-01-01') AND IFNULL((SELECT MAX(DATE)+5 FROM {{this}}),'2025-01-15')
{% else %}
WHERE DATE BETWEEN '2025-01-01' AND '2025-01-15'
{% endif %}
ORDER BY date DESC
