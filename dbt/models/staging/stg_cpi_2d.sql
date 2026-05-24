with source as (
    select * from {{ source('raw_malaysia', 'cpi_2d') }}
),

renamed as (
    select
        cast(date as date) as cpi_month,
        cast(division as string) as cpi_division,
        cast(index as numeric) as cpi_index
    from source
    where index is not null
)

select * from renamed
