with snapshot_dates as (
    select distinct
        sales_date as as_of_date
    from {{ ref('satellite_invoices') }}
),

item_effectivity as (
    select
        item_hk,
        sales_date as item_effective_start_date,
        lead(sales_date) over (
            partition by item_hk
            order by sales_date
        ) as item_effective_end_date
    from {{ ref('satellite_items') }}
),

item_category_link as (
    select
        item_hk,
        category_hk
    from {{ ref('LINK_ITEM_CATEGORIES') }}
),

category_effectivity as (
    select
        category_hk,
        sales_date as category_effective_start_date,
        lead(sales_date) over (
            partition by category_hk
            order by sales_date
        ) as category_effective_end_date
    from {{ ref('satellite_categories') }}
)

select
    sd.as_of_date,
    ie.item_hk,
    ic.category_hk,

    -- Item effectivity
    ie.item_effective_start_date,
    ie.item_effective_end_date,

    -- Category effectivity
    ce.category_effective_start_date,
    ce.category_effective_end_date,

    current_timestamp() as load_date
from snapshot_dates sd
join item_effectivity ie
    on sd.as_of_date >= ie.item_effective_start_date
   and (
        sd.as_of_date < ie.item_effective_end_date
        or ie.item_effective_end_date is null
   )
join item_category_link ic
    on ic.item_hk = ie.item_hk
join category_effectivity ce
    on ce.category_hk = ic.category_hk
   and sd.as_of_date >= ce.category_effective_start_date
   and (
        sd.as_of_date < ce.category_effective_end_date
        or ce.category_effective_end_date is null
   )
