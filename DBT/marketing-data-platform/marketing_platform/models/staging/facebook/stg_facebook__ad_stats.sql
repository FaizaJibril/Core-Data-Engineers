with source as (

    select * from {{ source('facebook_ads', 'ads_stats') }}

),

renamed as (

    select
        'facebook'                                          as platform,
        cast(ad_id as string)                               as ad_id,
        cast(account_id as string)                          as account_id,
        cast(ad_date as date)                               as ad_date,
        cast(ad_spend as decimal(18, 6))                    as spend,
        coalesce(cast(nullif(ad_impressions, 'null') as bigint), 0) as impressions,
        coalesce(cast(nullif(ad_clicks, 'null') as bigint), 0)      as clicks,
        nullif(ad_clicks, 'null') is null                   as is_clicks_missing,
        _ingested_at

    from source

)

select * from renamed
