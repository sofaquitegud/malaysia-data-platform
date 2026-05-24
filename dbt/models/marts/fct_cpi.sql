-- Grain: one row per division per month
with stg as (
    select * from {{ ref('stg_cpi_2d') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['cpi_month', 'cpi_division']) }} as cpi_id,
    cpi_month,
    cpi_division,
    cpi_index
from stg
order by cpi_month, cpi_division
