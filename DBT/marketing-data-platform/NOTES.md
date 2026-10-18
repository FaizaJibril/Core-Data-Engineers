# Notes

## Staging

- History tables are deduplicated in staging with `qualify row_number()`, keeping the latest version, to prevent join fan-out from doubling spend.
- Reconciliation: staging spend must equal bronze spend.
