SELECT
    item_number,
	category,
	sales_date,
    COUNT(*) AS cnt
FROM {{ ref('fct_sales_by_item_categories') }}
GROUP BY     item_number,
	category,
	sales_date
HAVING COUNT(*) > 1