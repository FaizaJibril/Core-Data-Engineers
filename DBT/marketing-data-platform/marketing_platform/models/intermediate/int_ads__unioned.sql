with facebook as (
    select * from {{ ref('int_facebook__ad_performance') }}
),
snapchat as (
    select * from {{ ref('int_snapchat__ad_performance') }}
),
unioned as (
    select * from facebook
    union all
    select * from snapchat
),
fx as (
    select * from {{ ref('fx_rates_to_eur') }}
)

select
    unioned.*,
    cast(unioned.spend * fx.eur_per_unit as decimal(18, 6)) as spend_eur

from unioned
left join fx
    on  unioned.currency_code = fx.currency_code
    and year(unioned.ad_date) = fx.rate_year
