select
    hv.STORE_NUMBER,
    sv.STORE_NAME,
    sv.store_location,
    sv.COUNTY,
    sv.COUNTY_NUMBER,
    sv.sales_date as start_date
from {{ ref('hub_stores') }} hv
join {{ ref('satellite_stores') }} sv
  on hv.store_hk = sv.store_hk
qualify row_number() over (
  partition by hv.store_hk
  order by sv.sales_date desc
) = 1