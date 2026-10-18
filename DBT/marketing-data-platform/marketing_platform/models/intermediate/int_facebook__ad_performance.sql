with stats as (
    select * from {{ ref('stg_facebook__ad_stats') }}
),
ads as (
    select * from {{ ref('stg_facebook__ads') }}
),
campaigns as (
    select * from {{ ref('stg_facebook__campaigns') }}
),
accounts as (
    select * from {{ ref('stg_facebook__accounts') }}
)

select
    stats.platform,
    stats.ad_date,
    stats.ad_id,
    ads.ad_name,
    ads.campaign_id,
    campaigns.campaign_name,
    stats.account_id,
    accounts.account_name,
    accounts.currency_code,
    stats.spend,
    stats.impressions,
    stats.clicks,
    stats.is_clicks_missing,
    stats._ingested_at

from stats
left join ads       on stats.ad_id = ads.ad_id
left join campaigns on ads.campaign_id = campaigns.campaign_id
left join accounts  on stats.account_id = accounts.account_id
