with source as (
    select * from {{ source('raw_malaysia', 'fuelprice') }}
),

renamed as (
    select
        cast(date as date) as price_date,
        cast(ron95 as numeric) as ron95_price_myr,
        cast(ron97 as numeric) as ron97_price_myr,
        cast(diesel as numeric) as diesel_price_myr,
        cast(diesel_eastmsia as numeric) as diesel_eastmsia_price_myr,
        cast(ron95_skps as numeric) as ron95_skps_price_myr,
        cast(ron95_budi95 as numeric) as ron95_budi95_price_myr
    from source
    where series_type = 'level'
)

select * from renamed
