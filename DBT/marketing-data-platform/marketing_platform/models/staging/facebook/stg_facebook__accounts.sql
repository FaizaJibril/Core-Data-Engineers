with source as (

    select * from {{ source('facebook_ads', 'accounts') }}

),

renamed as (

    select
        cast(account_id as string)       as account_id,
        account_name,
        upper(ad_currency_code)          as currency_code

    from source

)

select * from renamed
