-- Any rows returned = test failure
select price_date
from {{ ref('fct_fuel_prices') }}
where price_date > current_date()
