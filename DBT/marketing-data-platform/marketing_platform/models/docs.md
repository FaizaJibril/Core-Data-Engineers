{% docs grain_fct %}
One row per platform, ad and calendar day (ad_date). Snapchat country-level rows are summed to this grain.
{% enddocs %}

{% docs spend_eur %}
Spend converted to EUR using the annual average ECB reference rate for the year of ad_date (seed fx_rates_to_eur). Use this column to compare or total spend across platforms. Never sum `spend` across different currency_code values.
{% enddocs %}

{% docs ctr %}
Click-through rate = clicks / impressions. NULL when impressions = 0. Do not average this column; recompute as sum(clicks) / sum(impressions).
{% enddocs %}

{% docs cpc_eur %}
Cost per click in EUR = spend_eur / clicks. NULL when clicks = 0 (undefined, not free). Recompute from sums when aggregating.
{% enddocs %}

{% docs cpm_eur %}
Cost per 1,000 impressions in EUR = spend_eur / impressions x 1000. NULL when impressions = 0. Recompute from sums when aggregating.
{% enddocs %}
