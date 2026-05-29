-- Grain: one row per fuel_type per week
with stg as (
    select * from {{ ref('stg_fuelprice') }}
),

unpivoted as (
    select
        price_date,
        fuel_type,
        price_myr
    from stg
    unpivot (
        price_myr for fuel_type in (
            ron95_price_myr as 'RON95',
            ron97_price_myr as 'RON97',
            diesel_price_myr as 'Diesel'
        )
    )
)

select
    {{ dbt_utils.generate_surrogate_key(['price_date', 'fuel_type']) }} as fuel_price_id,
    price_date,
    fuel_type,
    price_myr
from unpivoted
order by price_date, fuel_type
