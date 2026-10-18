with stats as (
    select * from {{ ref('stg_snapchat__ad_stats') }}
),
ads as (
    select * from {{ ref('stg_snapchat__ads') }}
),
ad_groups as (
    select * from {{ ref('stg_snapchat__ad_groups') }}
),
campaigns as (
    select * from {{ ref('stg_snapchat__campaigns') }}
)

select
    stats.platform,
    stats.ad_date,
    stats.ad_id,
    ads.ad_name,
    ad_groups.campaign_id,
    campaigns.campaign_name,
    campaigns.account_id,
    cast(null as string) as account_name,
    stats.currency_code,
    stats.spend,
    stats.impressions,
    stats.clicks,
    stats.is_clicks_missing,
    stats._ingested_at

from stats
left join ads       on stats.ad_id = ads.ad_id
left join ad_groups on ads.ad_group_id = ad_groups.ad_group_id
left join campaigns on ad_groups.campaign_id = campaigns.campaign_id
