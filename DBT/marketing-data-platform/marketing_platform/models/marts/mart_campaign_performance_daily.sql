with fct as (
    select * from {{ ref('fct_ad_performance_daily') }}
),
campaigns as (
    select * from {{ ref('dim_campaign') }}
),
aggregated as (
    select
        fct.ad_date,
        fct.platform,
        fct.campaign_key,
        fct.campaign_id,
        campaigns.campaign_name,
        fct.currency_code,
        count(distinct fct.ad_id) as active_ads,
        sum(fct.spend)            as spend,
        sum(fct.spend_eur)        as spend_eur,
        sum(fct.impressions)      as impressions,
        sum(fct.clicks)           as clicks
    from fct
    left join campaigns on fct.campaign_key = campaigns.campaign_key
    group by all
)

select
    *,
    {{ safe_divide('clicks', 'impressions') }}           as ctr,
    {{ safe_divide('spend_eur', 'clicks') }}             as cpc_eur,
    {{ safe_divide('spend_eur', 'impressions') }} * 1000 as cpm_eur
from aggregated
