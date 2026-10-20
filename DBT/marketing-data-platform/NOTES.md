# Notes

## Staging

- History tables are deduplicated in staging with `qualify row_number()`, keeping the latest version, to prevent join fan-out from doubling spend.
- Reconciliation: staging spend must equal bronze spend.

## Production identity and grants

- Production dbt runs as the Service Principal `fai-dbt-cdc-marketing-prod` (Application ID `a57ae139-8cb6-4c18-b0b2-35a7d5a9b68c`), not as a person. Least privilege: the job gets only the permissions it needs, and no person's account is involved.
- **Authentication: OAuth M2M was the plan, but Databricks Free Edition blocks it.** The Service Principal's OAuth secret is valid, but the workspace refuses to grant it any scope (`access_denied: Scopes 'all-apis' are not assigned to the client`, same for `sql`). As a fallback, the Service Principal uses a token created on its behalf (on-behalf-of token): 90-day expiry, owned by the Service Principal, stored in the macOS Keychain (`dbt-marketing-prod-token`), never in the repo. Trade-off: it is long-lived rather than short-lived, so it must be rotated before expiry. On a paid workspace we would switch to OAuth M2M by changing only the dbt profile; no model code changes.
- Grants deliberately differ from the brief's example:
  - **No `CREATE SCHEMA` / `CREATE TABLE` on `bronze_production`.** The job only reads raw data; if it could write there, a bug in a model could corrupt the source of truth. Only the loading process writes to bronze.
  - **No `CREATE CATALOG ON METASTORE`.** That is a broad, metastore-level permission. The `production` catalog was created ahead of time by an admin, so the job never needs to create catalogs.
  - **No `MODIFY` on `production`.** The Service Principal creates its own schemas and tables there, which makes it their owner, and owners already have full rights on what they own.
- The Service Principal also needs **Can use** on the SQL warehouse; without it, no query runs regardless of data grants.
- `data_tests:` (dbt 1.10+) is used instead of `tests:` to distinguish data tests, which check real data, from unit tests, which check SQL logic against mock data.
