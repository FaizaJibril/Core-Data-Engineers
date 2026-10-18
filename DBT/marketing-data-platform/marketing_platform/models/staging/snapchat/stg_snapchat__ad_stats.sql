with source as (

    select * from {{ source('snapchat_ads', 'ads_stats') }}

),

renamed as (

    select
        cast(ad_detail_id as string)                        as ad_id,
        cast(ad_currency_code as string)                    as currency_code,
        cast(ad_date as date)                               as ad_date,
        cast(ad_spend as decimal(18, 6))                    as spend,
        coalesce(cast(nullif(ad_impressions, 'null') as bigint), 0) as impressions,
        coalesce(cast(nullif(ad_clicks, 'null') as bigint), 0)      as clicks,
        nullif(ad_clicks, 'null') is null                   as is_clicks_missing,
        _ingested_at

    from source

),

aggregated as (

    -- collapses ad_country: one row per ad_id per ad_date
    select
        'snapchat'                                          as platform,
        ad_id,
        ad_date,
        currency_code,
        sum(spend)                                          as spend,
        sum(impressions)                                    as impressions,
        sum(clicks)                                         as clicks,
        bool_or(is_clicks_missing)                          as is_clicks_missing,
        max(_ingested_at)                                   as _ingested_at

    from renamed
    group by ad_id, ad_date, currency_code

)

select * from aggregated
