select
    hv.CATEGORY,
    sv.CATEGORY_NAME,
    sv.sales_date as start_date
from {{ ref('hub_categories') }} hv
join {{ ref('satellite_categories') }} sv
  on hv.CATEGORY_HK = sv.CATEGORY_HK
qualify row_number() over (
  partition by hv.CATEGORY_HK
  order by sv.sales_date desc
) = 1