-- Grain: one row per operator per day
with stg as (
    select * from {{ ref('stg_ridership') }}
),

unpivoted as (
    select ridership_date, operator, passengers
    from stg
    unpivot (
        passengers for operator in (
            bus_rkl_passengers as 'bus_rkl',
            bus_rkn_passengers as 'bus_rkn',
            bus_rpn_passengers as 'bus_rpn',
            rail_lrt_ampang_passengers as 'rail_lrt_ampang',
            rail_mrt_kajang_passengers as 'rail_mrt_kajang',
            rail_lrt_kj_passengers as 'rail_lrt_kj',
            rail_monorail_passengers as 'rail_monorail',
            rail_mrt_pjy_passengers as 'rail_mrt_pjy',
            rail_ets_passengers as 'rail_ets',
            rail_intercity_passengers as 'rail_intercity',
            rail_komuter_utara_passengers as 'rail_komuter_utara',
            rail_tebrau_passengers as 'rail_tebrau',
            rail_komuter_passengers as 'rail_komuter'
        )
    )
)

select
    {{ dbt_utils.generate_surrogate_key(['ridership_date', 'operator']) }} as ridership_id,
    ridership_date,
    operator,
    passengers
from unpivoted
order by ridership_date, operator
