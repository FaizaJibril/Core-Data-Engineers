with source as (

    select * from {{ source('snapchat_ads', 'ads') }}

),

renamed as (

    select
        cast(ad_id as string)                   as ad_id,
        cast(ad_group_id as string)             as ad_group_id,
        ad_name,
        cast(ad_detail_updated_at as timestamp) as ad_updated_at

    from source

)

select * from renamed
