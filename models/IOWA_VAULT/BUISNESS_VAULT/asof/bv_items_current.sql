select
    hv.ITEM_NUMBER,
    sv.ITEM_DESCRIPTION,
    sv.sales_date as start_date
from {{ ref('hub_items') }} hv
join {{ ref('satellite_items') }} sv
  on hv.item_hk = sv.item_hk
qualify row_number() over (
  partition by hv.item_hk
  order by sv.sales_date desc
) = 1