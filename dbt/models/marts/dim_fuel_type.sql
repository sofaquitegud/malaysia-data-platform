select
    fuel_type,
    case fuel_type
        when 'RON95' then 'Subsidised petrol (RON 95)'
        when 'RON97' then 'Premium petrol (RON 97)'
        when 'Diesel' then 'Diesel (Peninsular Malaysia)'
    end as fuel_type_description,
    case fuel_type
        when 'RON95' then true
        when 'RON97' then false
        when 'Diesel' then true
    end as is_subsidised
from (select distinct fuel_type from {{ ref('fct_fuel_prices') }})
