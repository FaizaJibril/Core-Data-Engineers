-- One-time setup, run by a workspace admin in the Databricks SQL editor.
-- Catalogs separate environments; the landing volume holds the raw export files.

CREATE CATALOG IF NOT EXISTS bronze_production;   -- raw data, loaded as-is
CREATE CATALOG IF NOT EXISTS dev;                 -- developers' personal schemas (dbt target: dev)
CREATE CATALOG IF NOT EXISTS ci_development;      -- one schema set per pull request (dbt target: ci)
CREATE CATALOG IF NOT EXISTS production;          -- built only by the Service Principal (dbt target: prod)

CREATE SCHEMA IF NOT EXISTS bronze_production.landing;
CREATE VOLUME IF NOT EXISTS bronze_production.landing.raw_files;

CREATE SCHEMA IF NOT EXISTS bronze_production.facebook_ads;
CREATE SCHEMA IF NOT EXISTS bronze_production.snapchat_ads;

-- Then upload the provided CSVs to the volume (Catalog Explorer -> raw_files -> Upload):
--   /Volumes/bronze_production/landing/raw_files/facebook/*.csv
--   /Volumes/bronze_production/landing/raw_files/snapchat/*.csv
