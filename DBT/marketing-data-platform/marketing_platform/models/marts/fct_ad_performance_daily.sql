select
    {{ dbt_utils.generate_surrogate_key(['platform', 'ad_id', 'ad_date']) }} as ad_performance_key,
    {{ dbt_utils.generate_surrogate_key(['platform', 'campaign_id']) }}      as campaign_key,
    platform,
    ad_date,
    ad_id,
    ad_name,
    campaign_id,
    account_id,
    currency_code,
    spend,
    spend_eur,
    impressions,
    clicks,
    is_clicks_missing,
    _ingested_at

from {{ ref('int_ads__unioned') }}
