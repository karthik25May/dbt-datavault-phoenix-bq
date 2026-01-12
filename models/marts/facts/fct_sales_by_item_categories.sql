with invoice_base as (
    select
        invoiceitem_hk,        
        sales_date,
        sale_dollars,
        bottles_sold
    from {{ ref('satellite_invoices') }}
),

item_category_bridge as (
    select
        item_hk,
        category_hk,
        category_effective_end_date,
        category_effective_start_date,
        item_effective_end_date,
        item_effective_start_date,
        as_of_date
    from {{ ref('bridge_item_category') }}
),

category_sat as (
    select
        category_hk,
        category_name,
        sales_date
    from {{ ref('satellite_categories') }}
),

LINK_INVOICE_ITEM_STORE AS (
    select
        invoiceitem_hk,
        item_hk
    from {{ ref('LINK_INVOICE_ITEM_STORE') }}
),

LINK_ITEM_CATEGORIES as (
    select
        item_hk,
        category_hk
    from {{ ref('LINK_ITEM_CATEGORIES') }}
),


item_sat as (
    select
        item_hk,
        ITEM_DESCRIPTION,
        sales_date
    from {{ ref('satellite_items') }}
),

item_hub as (
    select
        item_hk,
        ITEM_NUMBER
    from {{ ref('hub_items') }}
),

category_hub as (
    select 
        category_hk,
        category
    from {{ ref('hub_categories') }}
)

select        
    -- item_sat.item_hk,
    -- c.category_hk,
    i_hub.ITEM_NUMBER,
    c_hub.category,
    c.category_name,    
    item_sat.ITEM_DESCRIPTION,
    i.sales_date,
    SUM(sale_dollars) AS SALES_AMOUNT,
    SUM(bottles_sold) AS TOTAL_BOTTLES_SOLD
from invoice_base i
-- join PIT to get correct item version
join LINK_INVOICE_ITEM_STORE lii 
  on i.invoiceitem_hk = lii.invoiceitem_hk
join LINK_ITEM_CATEGORIES lic
  on lii.item_hk = lic.item_hk
join item_category_bridge p
    on lic.item_hk = p.item_hk
    and lic.category_hk  = p.category_hk
    and i.sales_date = p.as_of_date
-- join link to get category_hk
-- join satellite to get descriptive attributes
join item_hub i_hub 
  on p.item_hk=i_hub.item_hk
join category_hub c_hub 
  on p.category_hk=c_hub.category_hk
join category_sat c
    on c.category_hk = p.category_hk
   and c.sales_date >= p.category_effective_start_date
   and (c.sales_date < p.category_effective_end_date or p.category_effective_end_date is null)
join item_sat item_sat
    on item_sat.item_hk = p.item_hk
   and item_sat.sales_date >= p.item_effective_start_date
   and (item_sat.sales_date < p.item_effective_end_date or p.item_effective_end_date is null)
GROUP BY ALL