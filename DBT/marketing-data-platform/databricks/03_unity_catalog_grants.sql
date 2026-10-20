-- Unity Catalog permissions, run by the catalog owner (a workspace admin).
-- Service Principal: fai-dbt-cdc-marketing-prod, Application ID a57ae139-8cb6-4c18-b0b2-35a7d5a9b68c
--
-- Deliberate differences from the brief's example grants (see README, "Security"):
--   * No CREATE SCHEMA / CREATE TABLE on bronze_production: the job only reads raw data, so a
--     model bug can never corrupt the source of truth. Only the loading process writes there.
--   * No CREATE CATALOG ON METASTORE: catalogs are created up front by an admin
--     (01_setup_catalogs.sql), so the job never needs a metastore-level privilege.
--   * No MODIFY on production: the Service Principal owns the schemas and tables it creates,
--     and owners already have full rights on what they own.

-- Production Service Principal: read raw data only
GRANT USE CATALOG ON CATALOG bronze_production TO `a57ae139-8cb6-4c18-b0b2-35a7d5a9b68c`;
GRANT USE SCHEMA  ON CATALOG bronze_production TO `a57ae139-8cb6-4c18-b0b2-35a7d5a9b68c`;
GRANT SELECT      ON CATALOG bronze_production TO `a57ae139-8cb6-4c18-b0b2-35a7d5a9b68c`;

-- Production Service Principal: build models in the production catalog
GRANT USE CATALOG   ON CATALOG production TO `a57ae139-8cb6-4c18-b0b2-35a7d5a9b68c`;
GRANT USE SCHEMA    ON CATALOG production TO `a57ae139-8cb6-4c18-b0b2-35a7d5a9b68c`;
GRANT CREATE SCHEMA ON CATALOG production TO `a57ae139-8cb6-4c18-b0b2-35a7d5a9b68c`;
GRANT CREATE TABLE  ON CATALOG production TO `a57ae139-8cb6-4c18-b0b2-35a7d5a9b68c`;

-- CI (runs as the developer): build and read in ci_development
GRANT USE CATALOG, USE SCHEMA, CREATE SCHEMA, CREATE TABLE, SELECT
  ON CATALOG ci_development TO `jayasibi99@gmail.com`;

-- Consumers (analysts, BI, AI agents): may enter the production catalog. Read access to the
-- data itself is granted by dbt on every prod run, on the marts schema only (macro
-- grant_marts_read_access), so staging and intermediate stay internal.
GRANT USE CATALOG ON CATALOG production TO `account users`;

-- Verify
SHOW GRANTS `a57ae139-8cb6-4c18-b0b2-35a7d5a9b68c` ON CATALOG bronze_production;
SHOW GRANTS `a57ae139-8cb6-4c18-b0b2-35a7d5a9b68c` ON CATALOG production;
SHOW GRANTS ON SCHEMA production.marts;
