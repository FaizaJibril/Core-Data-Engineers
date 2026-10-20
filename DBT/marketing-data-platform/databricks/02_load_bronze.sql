-- Loads the provided CSV exports into bronze, one table per file, exactly as delivered.
--
-- Design:
--   * inferColumnTypes => false: every column lands as STRING. Typing happens in dbt staging,
--     where a bad value fails the build loudly instead of being silently coerced here.
--   * _rescued_data (added by read_files): captures values that don't fit the header, so nothing is lost.
--   * _source_file / _ingested_at: lineage back to the exact file and load time.
--   * CREATE OR REPLACE: the exports are full snapshots, so a reload replaces the table.
--
-- Verified: re-reading the files with these options reproduces the current bronze tables
-- exactly (same columns, same order, same row counts).

CREATE OR REPLACE TABLE bronze_production.facebook_ads.ads_stats AS
SELECT
    *,
    _metadata.file_path AS _source_file,
    current_timestamp() AS _ingested_at
FROM read_files(
    '/Volumes/bronze_production/landing/raw_files/facebook/ads_stats.csv',
    format => 'csv',
    header => true,
    inferColumnTypes => false
);

CREATE OR REPLACE TABLE bronze_production.facebook_ads.ads AS
SELECT
    *,
    _metadata.file_path AS _source_file,
    current_timestamp() AS _ingested_at
FROM read_files(
    '/Volumes/bronze_production/landing/raw_files/facebook/new_ads_de_randomized.csv',
    format => 'csv',
    header => true,
    inferColumnTypes => false
);

CREATE OR REPLACE TABLE bronze_production.facebook_ads.ad_groups AS
SELECT
    *,
    _metadata.file_path AS _source_file,
    current_timestamp() AS _ingested_at
FROM read_files(
    '/Volumes/bronze_production/landing/raw_files/facebook/new_adgroup_de_randomized.csv',
    format => 'csv',
    header => true,
    inferColumnTypes => false
);

CREATE OR REPLACE TABLE bronze_production.facebook_ads.campaigns AS
SELECT
    *,
    _metadata.file_path AS _source_file,
    current_timestamp() AS _ingested_at
FROM read_files(
    '/Volumes/bronze_production/landing/raw_files/facebook/new_campaign_de_randomized.csv',
    format => 'csv',
    header => true,
    inferColumnTypes => false
);

CREATE OR REPLACE TABLE bronze_production.facebook_ads.accounts AS
SELECT
    *,
    _metadata.file_path AS _source_file,
    current_timestamp() AS _ingested_at
FROM read_files(
    '/Volumes/bronze_production/landing/raw_files/facebook/new_acccount_de_randomized.csv',
    format => 'csv',
    header => true,
    inferColumnTypes => false
);

CREATE OR REPLACE TABLE bronze_production.snapchat_ads.ads_stats AS
SELECT
    *,
    _metadata.file_path AS _source_file,
    current_timestamp() AS _ingested_at
FROM read_files(
    '/Volumes/bronze_production/landing/raw_files/snapchat/snapchat_ads_stats.csv',
    format => 'csv',
    header => true,
    inferColumnTypes => false
);

CREATE OR REPLACE TABLE bronze_production.snapchat_ads.ads AS
SELECT
    *,
    _metadata.file_path AS _source_file,
    current_timestamp() AS _ingested_at
FROM read_files(
    '/Volumes/bronze_production/landing/raw_files/snapchat/snapchat_ads_ad_history_new_ad_names.csv',
    format => 'csv',
    header => true,
    inferColumnTypes => false
);

CREATE OR REPLACE TABLE bronze_production.snapchat_ads.ad_groups AS
SELECT
    *,
    _metadata.file_path AS _source_file,
    current_timestamp() AS _ingested_at
FROM read_files(
    '/Volumes/bronze_production/landing/raw_files/snapchat/snapchat_ads_adgroup_history_new_ad_group_names.csv',
    format => 'csv',
    header => true,
    inferColumnTypes => false
);

CREATE OR REPLACE TABLE bronze_production.snapchat_ads.campaigns AS
SELECT
    *,
    _metadata.file_path AS _source_file,
    current_timestamp() AS _ingested_at
FROM read_files(
    '/Volumes/bronze_production/landing/raw_files/snapchat/snapchat_ads_campaign_history_new_campaign_names.csv',
    format => 'csv',
    header => true,
    inferColumnTypes => false
);
