with source as (
    select * from {{ source('raw_malaysia', 'ridership_headline') }}
),

renamed as (
    select
        cast(date as date) as ridership_date,
        cast(bus_rkl as int64) as bus_rkl_passengers,
        cast(bus_rkn as int64) as bus_rkn_passengers,
        cast(bus_rpn as int64) as bus_rpn_passengers,
        cast(rail_lrt_ampang as int64) as rail_lrt_ampang_passengers,
        cast(rail_mrt_kajang as int64) as rail_mrt_kajang_passengers,
        cast(rail_lrt_kj as int64) as rail_lrt_kj_passengers,
        cast(rail_monorail as int64) as rail_monorail_passengers,
        cast(rail_mrt_pjy as int64) as rail_mrt_pjy_passengers,
        cast(rail_ets as int64) as rail_ets_passengers,
        cast(rail_intercity as int64) as rail_intercity_passengers,
        cast(rail_komuter_utara as int64) as rail_komuter_utara_passengers,
        cast(rail_tebrau as int64) as rail_tebrau_passengers,
        cast(rail_komuter as int64) as rail_komuter_passengers
    from source
)

select * from renamed
