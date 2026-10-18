-- Fails if any spend was lost or double-counted between bronze and the fact table.
with bronze as (
    select 'facebook' as platform, sum(cast(ad_spend as decimal(18, 6))) as spend
    from {{ source('facebook_ads', 'ads_stats') }}
    union all
    select 'snapchat', sum(cast(ad_spend as decimal(18, 6)))
    from {{ source('snapchat_ads', 'ads_stats') }}
),
fct as (
    select platform, sum(spend) as spend
    from {{ ref('fct_ad_performance_daily') }}
    group by platform
)

select
    coalesce(bronze.platform, fct.platform) as platform,
    bronze.spend as bronze_spend,
    fct.spend    as fct_spend
from bronze
full outer join fct on bronze.platform = fct.platform
where abs(coalesce(bronze.spend, 0) - coalesce(fct.spend, 0)) > 0.01
