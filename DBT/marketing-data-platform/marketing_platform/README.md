# marketing_platform (dbt project)

The dbt project for the Marketing Data Platform. Full documentation (architecture, model design, materializations, tests, environments, security and setup) is in the project README: [`../README.md`](../README.md).

Quick start, from this folder:

```bash
source ../.env
dbt deps
dbt build              # dev
dbt build --target ci  # what CI runs
```

Production is deployed by GitHub Actions on merge to `main`, as the Service Principal.
