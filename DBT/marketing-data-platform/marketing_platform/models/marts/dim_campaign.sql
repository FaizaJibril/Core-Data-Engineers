with facebook as (
    select 'facebook' as platform, campaign_id, campaign_name
    from {{ ref('stg_facebook__campaigns') }}
),
snapchat as (
    select 'snapchat' as platform, campaign_id, campaign_name
    from {{ ref('stg_snapchat__campaigns') }}
),
unioned as (
    select * from facebook
    union all
    select * from snapchat
)

select
    {{ dbt_utils.generate_surrogate_key(['platform', 'campaign_id']) }} as campaign_key,
    platform,
    campaign_id,
    campaign_name
from unioned
