<p align="center">
    <a alt="License"
        href="https://github.com/fivetran/dbt_linkedin_source/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_,<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
    <a alt="Fivetran Quickstart Compatible"
        href="https://fivetran.com/docs/transformations/dbt/quickstart">
        <img src="https://img.shields.io/badge/Fivetran_Quickstart_Compatible%3F-yes-green.svg" /></a>
</p>

# LinkedIn Ad Analytics Source dbt Package ([docs](https://fivetran.github.io/dbt_linkedin_source/))

## What does this dbt package do?
<!--section="linkedin_ads_source_model"-->
- Materializes [Linkedin Ads Analytics staging tables](https://fivetran.github.io/dbt_linkedin_source/#!/overview/linkedin_source/models/?g_v=1&g_e=seeds) which leverage data in the format described by [this ERD](https://fivetran.com/docs/applications/linkedin-ads#schemainformation). These staging tables clean, test, and prepare your Linkedin Ads Analytics data from [Fivetran's connector](https://fivetran.com/docs/applications/linkedin-ads) for analysis by doing the following:
  - Name columns for consistency across all packages and for easier analysis
  - Adds freshness tests to source data
  - Adds column-level testing where applicable. For example, all primary keys are tested for uniqueness and non-null values.
- Generates a comprehensive data dictionary of your Linkedin Ad Analytics data through the [dbt docs site](https://fivetran.github.io/dbt_linkedin_source/).
- These tables are designed to work simultaneously with our [Linkedin Ads transformation package](https://github.com/fivetran/dbt_linkedin).
<!--section-end-->

## How do I use the dbt package?
### Step 1: Prerequisites
To use this dbt package, you must have the following:
- At least one Fivetran Linkedin Ad Analytics connector syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

#### Databricks Dispatch Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
# dbt_project.yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

### Step 2: Install the package (skip if also using the `linkedin` transformation package, or `ad_reporting` combination package)
If you  are **not** using the [Linkedin transformation package](https://github.com/fivetran/dbt_linkedin) and/or [Ad Reporting transformation package](https://github.com/fivetran/dbt_ad_reporting), include the following package version in your `packages.yml` file. If you are installing the transform package, the source package is automatically installed as a dependency.
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yml
# packages.yml
packages:
  - package: fivetran/linkedin_source
    version: [">=0.10.0", "<0.11.0"]
```

### Step 3: Define database and schema variables
By default, this package runs using your destination and the `linkedin_ads` schema. If this is not where your Linkedin Ads data is (for example, if your linkedin schema is named `linkedin_ads_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
# dbt_project.yml
vars:
    linkedin_ads_database: your_destination_name
    linkedin_ads_schema: your_schema_name
```

### (Optional) Step 4: Additional configurations
#### Union multiple connectors
If you have multiple linkedin connectors in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. The package will union all of the data together and pass the unioned table into the transformations. You will be able to see which source it came from in the `source_relation` column of each model. To use this functionality, you will need to set either the `linkedin_ads_union_schemas` OR `linkedin_ads_union_databases` variables (cannot do both) in your root `dbt_project.yml` file:

```yml
vars:
    linkedin_ads_union_schemas: ['linkedin_usa','linkedin_canada'] # use this if the data is in different schemas/datasets of the same database/project
    linkedin_ads_union_databases: ['linkedin_usa','linkedin_canada'] # use this if the data is in different databases/projects but uses the same schema name
```
> NOTE: The native `source.yml` connection set up in the package will not function when the union schema/database feature is utilized. Although the data will be correctly combined, you will not observe the sources linked to the package models in the Directed Acyclic Graph (DAG). This happens because the package includes only one defined `source.yml`.

To connect your multiple schema/database sources to the package models, follow the steps outlined in the [Union Data Defined Sources Configuration](https://github.com/fivetran/dbt_fivetran_utils/tree/releases/v0.4.latest#union_data-source) section of the Fivetran Utils documentation for the union_data macro. This will ensure a proper configuration and correct visualization of connections in the DAG.

#### Switching to Local Currency for Costs
Additionally, the package allows you to select whether you want to add in costs in USD or the local currency of the ad. By default, the package uses USD. If you would like to have costs in the local currency, add the following variable to your `dbt_project.yml` file:

```yml
# dbt_project.yml
vars:
    linkedin_ads__use_local_currency: True # false by default -- uses USD
```

**Note**: Unlike cost, conversion values are only available in the local currency. The package will only use the `conversion_value_in_local_currency` field for conversion values, while it may draw from the `cost_in_local_currency` and `cost_in_usd` source fields for cost.

#### Passing Through Additional Metrics
By default, this package will select `clicks`, `impressions`, `cost` and `conversion_value_in_local_currency` (as well as fields set via `linkedin_ads__conversion_fields` in the next section) from the source reporting tables `ad_analytics_by_campaign` and `ad_analytics_by_creative` to store into the corresponding staging models. If you would like to pass through additional metrics to the staging models, add the below configurations to your `dbt_project.yml` file. These variables allow for the pass-through fields to be aliased (`alias`) and transformed (`transform_sql`) if desired, but not required. Only the `name` of each metric field is required. Use the below format for declaring the respective pass-through variables:

```yml
# dbt_project.yml
vars:
    linkedin_ads__campaign_passthrough_metrics: # pulls from ad_analytics_by_campaign
        - name: "new_custom_field"
          alias: "custom_field_alias"
          transform_sql: "coalesce(custom_field_alias, 0)" # reference the `alias` here if you are using one
        - name: "unique_int_field"
          alias: "field_id"
        - name: "another_one"
          transform_sql: "coalesce(another_one, 0)" # reference the `name` here if you're not using an alias
        - name: "that_field"
    linkedin_ads__creative_passthrough_metrics: # pulls from ad_analytics_by_creative
        - name: "new_custom_field"
          alias: "custom_field"
        - name: "unique_int_field"
```

>**Note** Please ensure you exercised due diligence when adding metrics to these models. The metrics added by default (clicks, impressions, and spend) have been vetted by the Fivetran team maintaining this package for accuracy. There are metrics included within the source reports, for example metric averages, which may be inaccurately represented at the grain for reports created in this package. You will want to ensure whichever metrics you pass through are indeed appropriate to aggregate at the respective reporting levels provided in this package. (**Important**: You do not need to add conversions in this way. See the following section for an alternative implementation.)

#### Adding in Conversion Fields Variable
Separate from the above passthrough metrics, the package will also include conversion metrics based on the `linkedin_ads__conversion_fields` variable, in addition to the `conversion_value_in_local_currency` field.

By default, the data models consider `external_website_conversions` and `one_click_leads` to be conversions. These should cover most use cases, but, say, if you would like to consider landing page clicks and external post click conversions to *also* be conversions, you would apply the following configuration with the **original** source names of the conversion fields (not aliases you provided in the section above):

```yml
# dbt_project.yml
vars:
    linkedin_ads__conversion_fields: ['external_website_conversions',  'one_click_leads', 'external_website_post_click_conversions', 'landing_page_clicks']
```

Make sure to follow best practices in configuring fields in the conversion field variables! [See the DECISIONLOG for more details](https://github.com/fivetran/dbt_linkedin_source/blob/main/DECISIONLOG.md#best-practices-with-configuring-linkedin-ads-conversion-fields-variable).

> We introduced support for conversion fields in our `ad_analytics_by_campaign` and `ad_analytics_by_creative` data models in the [v0.9.0 release](https://github.com/fivetran/dbt_linkedin_source/releases/tag/v0.9.0) of the package, but customers might have been bringing in these conversion fields earlier using the passthrough fields variables. The data models will avoid "duplicate column" errors automatically if this is the case.

#### Change the build schema
By default, this package builds the Linkedin Ads staging models within a schema titled (`<target_schema>` + `_linkedin_ads_source`) in your destination. If this is not where you would like your Linkedin staging data to be written to, add the following configuration to your root `dbt_project.yml` file:

```yml
# dbt_project.yml
models:
    linkedin_source:
        +schema: my_new_schema_name # leave blank for just the target_schema
```

#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable. This is not available when running the package on multiple unioned connectors.

> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_linkedin_source/blob/main/dbt_project.yml) variable declarations to see the expected names.
    
```yml
# dbt_project.yml
vars:
    linkedin_ads_<default_source_table_name>_identifier: your_table_name 
```

### (Optional) Step 5: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for more details</summary>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core™ setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).

</details>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.
```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]
    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]
    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```

## How is this package maintained and can I contribute?
### Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend that you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/linkedin_source/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_linkedin_source/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

#### Contributors
We thank [everyone](https://github.com/fivetran/dbt_linkedin_source/graphs/contributors) who has taken the time to contribute. Each PR, bug report, and feature request has made this package better and is truly appreciated.

A special thank you to [Seer Interactive](https://www.seerinteractive.com/?utm_campaign=Fivetran%20%7C%20Models&utm_source=Fivetran&utm_medium=Fivetran%20Documentation), who we closely collaborated with to introduce native conversion support to our Ad packages.

## Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_linkedin_source/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
