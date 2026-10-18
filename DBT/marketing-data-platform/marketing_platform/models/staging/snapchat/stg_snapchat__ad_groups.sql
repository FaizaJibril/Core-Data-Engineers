with source as (

    select * from {{ source('snapchat_ads', 'ad_groups') }}

),

renamed as (

    select
        cast(ad_group_id as string)            as ad_group_id,
        cast(campaign_id as string)            as campaign_id,
        ad_group_name,
        cast(ad_group_updated_at as timestamp) as ad_group_updated_at

    from source

),

deduplicated as (

    -- source is a history table: keep only the latest version of each ad group
    select *
    from renamed
    qualify row_number() over (
        partition by ad_group_id
        order by ad_group_updated_at desc
    ) = 1

)

select * from deduplicated
