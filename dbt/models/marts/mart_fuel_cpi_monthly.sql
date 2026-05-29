-- Grain: one row per fuel_type per month, joined with Transport CPI (division 07)
with monthly_fuel as (
    select
        date_trunc(price_date, month) as price_month,
        fuel_type,
        round(avg(price_myr), 3) as avg_price_myr,
        min(price_myr) as min_price_myr,
        max(price_myr) as max_price_myr,
        count(*) as weekly_observations
    from {{ ref('fct_fuel_prices') }}
    group by 1, 2
),

transport_cpi as (
    select
        cpi_month,
        cpi_index as transport_cpi_index
    from {{ ref('fct_cpi') }}
    where cpi_division = '07'
),

joined as (
    select
        f.price_month,
        f.fuel_type,
        f.avg_price_myr,
        f.min_price_myr,
        f.max_price_myr,
        f.weekly_observations,
        c.transport_cpi_index
    from monthly_fuel f
    left join transport_cpi c on f.price_month = c.cpi_month
)

select * from joined
order by price_month, fuel_type
