with source as (

    select * from {{ source('facebook_ads', 'ads') }}

),

renamed as (

    select
        cast(ad_id as string)            as ad_id,
        cast(campaign_id as string)      as campaign_id,
        cast(ad_group_id as string)      as ad_group_id,
        cast(account_id as string)       as account_id,
        ad_name,
        lower(ad_status)                 as ad_status,
        cast(ad_updated_at as timestamp) as ad_updated_at

    from source

)

select * from renamed
