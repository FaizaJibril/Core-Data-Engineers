Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

### Assumptions

- **FX conversion (`spend_eur`)** uses one annual average rate per currency and year, from the `fx_rates_to_eur` seed (USD 2025: ECB annual average reference rate, 1 EUR = 1.1300 USD). That is accurate enough to compare platforms, but not for finance reconciliation. A production setup would load daily rates from an FX feed.
- The seed has no USD rate for 2024, because no USD spend exists in 2024. A test will fail if a currency/year without a rate ever appears.
