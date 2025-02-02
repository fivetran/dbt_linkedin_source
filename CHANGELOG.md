# dbt_linkedin_source version.version

## Documentation
- Corrected references to connectors and connections in the README. ([#73](https://github.com/fivetran/dbt_linkedin_source/pull/73))

# dbt_linkedin_source v0.10.0
[PR #69](https://github.com/fivetran/dbt_linkedin_source/pull/69) includes the following updates:

## Breaking Changes
- The `click_uri_type` field has been added to the `stg_linkedin_ads__creative_history` model. This field allows users to differentiate which click uri type (`text_ad` or `spotlight`) is being used to populate the results of the `click_uri` field. 
  - Please be aware this field only supports `text_ad` or `spotlight` click uri types. If you are interested in this package supporting more click uri ad types, please let us know in this [Feature Request](https://github.com/fivetran/dbt_linkedin_source/issues/70).

## Bug Fixes
- The `click_uri` field has been adjusted to populate the results following a coalesce on the `text_ad_landing_page`, `spotlight_landing_page`, or `click_uri` fields. 
  - This change is in response to a [LinkedIn Ads API](https://learn.microsoft.com/en-us/linkedin/marketing/community-management/contentapi-migration-guide?view=li-lms-2024-05#adcreativesv2-api-creatives-api) and [Fivetran LinkedIn Ads connector update](https://fivetran.com/docs/connectors/applications/linkedin-ads/changelog#january2024) which moved `click_uri` data to either the `text_ad_landing_page` or `spotlight_landing_page` fields depending on the creative type.
- Updated the `is_latest_version` window function in the following models to exclude the `source_relation` field from the partition statement when `linkedin_ads_union_schemas` or `linkedin_ads_union_databases` variables are empty in the following models:
    - `stg_linkedin_ads__account_history`
    - `stg_linkedin_ads__campaign_group_history`
    - `stg_linkedin_ads__campaign_history`
    - `stg_linkedin_ads__creative_history`
- In addition to the above, the `is_latest_version` window function within the `stg_linkedin_ads__creative_history` model has been moved to the final cte to avoid possible constant expression errors within Redshift destinations.

## Under the Hood
- Updates to the `linkedin_creative_history_data` seed file to include the following new fields to ensure accurate data validation tests:
  - `text_ad_landing_page`
  - `spotlight_landing_page`

## Documentation Updates
- Added `click_uri_type` field documentation.
- The `click_uri` field documentation has been updated to reflect the updated state of the field.

# dbt_linkedin_source v0.9.0
[PR #67](https://github.com/fivetran/dbt_linkedin_source/pull/67) includes the following updates:

## 🚨 Breaking Changes 🚨
## Feature Updates: Conversion Support!
We have added more robust support for conversions in our data models by doing the following: 
- Created a `linkedin_ads__conversion_fields` variable to pass through additional conversion metrics in the `stg_linkedin_ads__ad_analytics_by_campaign` and `stg_linkedin_ads__ad_analytics_by_creative` models. 
  - Set variable defaults in the `dbt_project.yml` to bring in the most used conversion fields `external_website_conversions` and `one_click_leads`. 
- Ensured backwards compatibility with existing passthrough column variables in these models by creating macro checks for whether these fields already are brought in by the existing passthrough variables. This ensures there are no duplicate column errors if both the new conversion variable and the old passthrough variable are leveraged in either `stg_linkedin_ads__ad_analytics_by_*` data model. 
- Brought in the `conversion_value_in_local_currency` field to the above mentioned `stg_linkedin_ads__ad_analytics_by_*` models.
> The above new field additions are 🚨 **breaking changes** 🚨 for users who were not already bringing in conversion fields via passthrough columns.

## Documentation Update 
- Documents the ability to transform metrics provided to the `linkedin_ads__campaign_passthrough_metrics` and `linkedin_ads__creative_passthrough_metrics` variables [in the README](https://github.com/fivetran/dbt_linkedin_source/blob/main/README.md#adding-in-conversion-fields-variable).
- Added new metrics to `src` and `stg` yml files.

## Under the Hood
- Updated `linkedin_ad_analytics_by_creative_data` seed file with relevant conversion fields for more robust testing. 

## Contributors
- [Seer Interactive](https://www.seerinteractive.com/?utm_campaign=Fivetran%20%7C%20Models&utm_source=Fivetran&utm_medium=Fivetran%20Documentation)

# dbt_linkedin_source v0.8.2
[PR #66](https://github.com/fivetran/dbt_linkedin_source/pull/66) includes the following updates:
## Bug Fixes
- Adjusted the logic for determining the values of the `is_latest_version`, `last_modified_at`, `status`, and `created_at` fields in the `stg_linkedin_ads__creative_history` model for pre-January 2023 Fivetran connectors. 
  - This ensures proper handling of retroactively filled `last_modified_at` values and maintains consistency in the `COALESCE` ordering for the `status` and `created_at` fields.
  - See the [January 2023 Fivetran connector release notes](https://fivetran.com/docs/applications/linkedin-ads/changelog#january2023) for more information.

# dbt_linkedin_source v0.8.1

[PR #64](https://github.com/fivetran/dbt_linkedin_source/pull/64) includes the following updates:
## Bug Fixes
- This package now leverages the new `linkedin_ads_extract_url_parameter()` macro for use in parsing out url parameters. This was added to create special logic for Databricks instances not supported by `dbt_utils.get_url_parameter()`.
  - This macro will be replaced with the `fivetran_utils.extract_url_parameter()` macro in the next breaking change of this package.
## Under the Hood
- Included auto-releaser GitHub Actions workflow to automate future releases.

# dbt_linkedin_source v0.8.0
[PR #54](https://github.com/fivetran/dbt_linkedin_source/pull/54) includes the following updates:

## Breaking changes
- Updated materializations of non-`tmp` staging models from views to tables. This is to bring the materializations into alignment with other ad reporting packages and eliminate errors in Redshift. 
- Updated the name of the source created by this package from `linkedin` to `linkedin_ads`. This was to bring the naming used in this package in alignment with our other ad packages and for compatibility with the union schema feature.
  - ❗ If you are using this source, you will need to update the name.
- Updated the following identifiers for consistency with the source name and compatibility with the union schema feature:

| current  | previous |
|----------|----------|
| linkedin_ads_account_history_identifier | linkedin_account_history_identifier
| linkedin_ads_ad_analytics_by_creative_identifier | linkedin_ad_analytics_by_creative_identifier
| linkedin_ads_campaign_group_history_identifier | linkedin_campaign_group_history_identifier
| linkedin_ads_campaign_history_identifier | linkedin_campaign_history_identifier
| linkedin_ads_creative_history_identifier | linkedin_creative_history_identifier
| linkedin_ads_ad_analytics_by_campaign_identifier | linkedin_ad_analytics_by_campaign_identifier

- If you are using the previous identifier, be sure to update to the current version!

## Feature update 🎉
- Unioning capability! This adds the ability to union source data from multiple linkedin connectors. Refer to the [Union Multiple Connectors README section](https://github.com/fivetran/dbt_linkedin_source/blob/main/README.md#union-multiple-connectors) for more details.

## Under the hood 🚘
- Updated tmp models to union source data using the `fivetran_utils.union_data` macro. 
- To distinguish which source each field comes from, added `source_relation` column in each staging model and applied the `fivetran_utils.source_relation` macro.
- Updated tests to account for the new `source_relation` column.

[PR #51](https://github.com/fivetran/dbt_linkedin_source/pull/51) includes the following updates:
- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job.
- Updated the pull request [templates](/.github).

# dbt_linkedin_source v0.7.0
## 🚨 Breaking Changes 🚨
Due to Linkedin Ads API [change in January 2023](https://learn.microsoft.com/en-us/linkedin/marketing/integrations/recent-changes?view=li-lms-2022-12#january-2023), there have been updates in the Linkedin Ads Fivetran Connector and therefore, updates to this Linkedin package. 

The following fields have been completely deprecated in the `stg_linkedin_ads__creative_history` model ([PR #48](https://github.com/fivetran/dbt_linkedin_source/pull/48)):
- `type`
- `call_to_action_label_type`
- `version_tag`

## Updates
[PR #48](https://github.com/fivetran/dbt_linkedin_source/pull/48) includes the below modifications:
- The following legacy fields have been updated respectively in the connector:
  - `last_modified_time` has been updated to `last_modified_at`
  - `created_time` has been updated to `created_at`
  - `status` has been updated to `intended_status`
- `src_linkedin.yml` have been updated to reflect new definitions for the above updated fields.
- Removing unique column testing from `stg_linkedin__creative_history` as a result of the recent [API version update](https://fivetran.com/docs/applications/linkedin-ads/changelog#january2023) that impacted the `CREATIVE_HISTORY` table. We were recently made aware of an edge case that results in duplicate records for a given `Creative ID` due to a primary key change (`last_modified_time` to `last_modified_at`). Duplicate data will appear if a creative was deleted from the LinkedIn Ads platform during the API update process -- the likelihood of this happening is small and it would only impact deleted creatives.

## Under the Hood
- `integration_tests/seeds/linkedin_creative_history_data` has been updated to reflect new fields and deprecated fields
- `_fivetran_synced` field removed from seed data for `linkedin_ad_analytics_by_campaign_data` integration testing as it is not used in this package's models

# dbt_linkedin_source v0.6.0

## 🚨 Breaking Changes 🚨:
[PR #47](https://github.com/fivetran/dbt_linkedin_source/pull/47) includes the following breaking changes:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- `packages.yml` has been updated to reflect new default `fivetran/fivetran_utils` version, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.

# dbt_linkedin_source v0.5.0

PR [#46](https://github.com/fivetran/dbt_linkedin_source/pull/46) includes the following changes:

## 🚨 Breaking Changes 🚨
- **ALL** staging models and **ALL** variables now have the prefix `linkedin_ads_*`. They previously were prepended with `linkedin_*`. This includes the required schema and database variables. We made this change to better discern between Linkedin Ads and [Linkedin Pages](https://github.com/fivetran/dbt_linkedin_pages/tree/main).
- Staging models are now by default written within a schema titled (`<target_schema>` + `_linkedin_ads_source`) in your destination. Previously, this was titled (`<target_schema>` + `_stg_linkedin`).
- The declaration of passthrough variables within your root `dbt_project.yml` has changed. To allow for more flexibility and better tracking of passthrough columns, you will now want to define passthrough columns in the following format:
```yml
vars:
  linkedin_ads__creative_passthrough_metrics: # NOTE that this used to be called linkedin__passthrough_metrics
    - name: "my_field_to_include" # Required: Name of the field within the source.
      alias: "field_alias" # Optional: If you wish to alias the field within the staging model.
  linkedin_ads__campaign_passthrough_metrics: # This will pull from `ad_analytics_by_campaign`
    - name: "my_field_to_include"
      alias: "field_alias"
```

## 🎉 Feature Enhancements 🎉
- Addition of the `stg_linkedin_ads__ad_analytics_by_campaign` model. This is to generate a more accurate representation of Linkedin Ad Analytics data at the campaign level.
- README updates for easier navigation and use of the package.
- Addition of identifier variables for each of the source tables to allow for further flexibility in source table direction within the dbt project.
- Additional columns included in `_history` staging models.

- # dbt_linkedin_source v0.4.1
## Fixes
- All timestamp fields within the staging models have been cast using `{{ dbt_utils.type_timestamp() }}`. This is needed as the timestamps need to be consistently cast in order for downstream date functions to succeed.
# dbt_linkedin_source v0.4.0
🎉 dbt v1.0.0 Compatibility 🎉
## 🚨 Breaking Changes 🚨
- Adjusts the `require-dbt-version` to now be within the range [">=1.0.0", "<2.0.0"]. Additionally, the package has been updated for dbt v1.0.0 compatibility. If you are using a dbt version <1.0.0, you will need to upgrade in order to leverage the latest version of the package.
  - For help upgrading your package, I recommend reviewing this GitHub repo's Release Notes on what changes have been implemented since your last upgrade.
  - For help upgrading your dbt project to dbt v1.0.0, I recommend reviewing dbt-labs [upgrading to 1.0.0 docs](https://docs.getdbt.com/docs/guides/migration-guide/upgrading-to-1-0-0) for more details on what changes must be made.
- Upgrades the package dependency to refer to the latest `dbt_fivetran_utils`. The latest `dbt_fivetran_utils` package also has a dependency on `dbt_utils` [">=0.8.0", "<0.9.0"].
  - Please note, if you are installing a version of `dbt_utils` in your `packages.yml` that is not in the range above then you will encounter a package dependency error.

# dbt_linkedin_source v0.1.0 -> v0.3.0
Refer to the relevant release notes on the Github repository for specific details for the previous releases. Thank you!
