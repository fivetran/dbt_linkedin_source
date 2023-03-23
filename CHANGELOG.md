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
