select
    hv.VENDOR_NUMBER,
    sv.vendor_name,
    sv.sales_date as start_date
from {{ ref('hub_vendors') }} hv
join {{ ref('satellite_vendors') }} sv
  on hv.vendor_hk = sv.vendor_hk
qualify row_number() over (
  partition by hv.vendor_hk
  order by sv.sales_date desc
) = 1