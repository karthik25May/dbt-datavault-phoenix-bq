with item_base as (
    select
        item_hk,
        item_hashdiff,
        item_description,
        sales_date as effective_start_date,
        lead(sales_date) over (
            partition by item_hk
            order by sales_date
        ) as effective_end_date
    from {{ ref('satellite_items') }}
),

item_category as (
    select
        item_hk,
        category_hk
    from {{ ref('LINK_ITEM_CATEGORIES') }}
),

category_base as (
    select
        category_hk,
        category_name,
        sales_date
    from {{ ref('satellite_categories') }}
)

select
    ib.item_hk,
    cb.category_hk,
    ib.item_description,
    cb.category_name,
    ib.effective_start_date,
    ib.effective_end_date
from item_base ib
join item_category ic
    on ic.item_hk = ib.item_hk
join category_base cb
    on cb.category_hk = ic.category_hk
   and cb.sales_date >= ib.effective_start_date
   and (
        cb.sales_date < ib.effective_end_date
        or ib.effective_end_date is null
   )
qualify row_number() over (
    partition by ib.item_hk, ib.effective_start_date
    order by cb.sales_date desc
) = 1
