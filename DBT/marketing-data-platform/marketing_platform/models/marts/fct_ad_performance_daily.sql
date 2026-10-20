{{
    config(
        materialized='incremental',
        unique_key='ad_performance_key',
        incremental_strategy='merge',
        on_schema_change='fail'
    )
}}

-- Incremental: daily refreshes only reprocess recent days instead of rebuilding all history.
-- Ad platforms restate recent days (late conversions, spend corrections), so each run
-- re-merges a lookback window rather than only rows newer than the last run.
{% set lookback_days = var('fct_lookback_days', 3) %}

with source as (

    select * from {{ ref('int_ads__unioned') }}

){% if is_incremental() %},

-- per platform, because each platform's data can end on a different day
watermarks as (

    select
        platform,
        date_sub(max(ad_date), {{ lookback_days }}) as reprocess_from
    from {{ this }}
    group by platform

){% endif %}

select
    {{ dbt_utils.generate_surrogate_key(['source.platform', 'source.ad_id', 'source.ad_date']) }} as ad_performance_key,
    {{ dbt_utils.generate_surrogate_key(['source.platform', 'source.campaign_id']) }}             as campaign_key,
    source.platform,
    source.ad_date,
    source.ad_id,
    source.ad_name,
    source.campaign_id,
    source.account_id,
    source.currency_code,
    source.spend,
    source.spend_eur,
    source.impressions,
    source.clicks,
    source.is_clicks_missing,
    source._ingested_at

from source

{% if is_incremental() %}
left join watermarks
    on source.platform = watermarks.platform
-- a platform not yet in the table has no watermark, so all of its rows load
where watermarks.reprocess_from is null
   or source.ad_date >= watermarks.reprocess_from
{% endif %}
