{{ config(
    materialized = 'incremental',
    incremental_strategy = 'merge',
    unique_key = 'invoice_and_item_number'
) }}
SELECT * FROM `bigquery-public-data.iowa_liquor_sales.sales` 
{% if is_incremental() %}
WHERE DATE BETWEEN IFNULL((SELECT MAX(DATE)+1 FROM {{this}}),'2025-01-01') AND IFNULL((SELECT MAX(DATE)+5 FROM {{this}}),'2025-01-15')
{% else %}
WHERE DATE BETWEEN '2025-01-01' AND '2025-01-15'
{% endif %}
ORDER BY date DESC
