# LinkedIn Ads (Source)

This package models LinkedIn Ads data from [Fivetran's connector](https://fivetran.com/docs/applications/linkedin-ads). It uses data in the format described by [this ERD](https://docs.google.com/presentation/d/1nwR5efra1p3S1uOwUgU9Wdx7WBKXE7onxNDffK0IpgM/edit#slide=id.g311502b468_5_443).

This package enriches your Fivetran data by doing the following:

* Adds descriptions to tables and columns that are synced using Fivetran
* Adds column-level testing where applicable. For example, all primary keys are tested for uniqueness and non-null values.
* Models staging tables, which will be used in our transform package

## Models

This package contains staging models, designed to work simultaneously with our [LinkedIn Ads modeling package](https://github.com/fivetran/dbt_linkedin). The staging models:

* Name columns consistently across all packages:
* Boolean fields are prefixed with is_ or has_
* Timestamps are appended with _at
* ID primary keys are prefixed with the name of the table. For example, the campaign table's ID column is renamed campaign_id.

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

## Configuration
By default this package will look for your Linkedin Ads data in the `linkedin_ads` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your LinkedIn Ads data is, please add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    linkedin_schema: your_database_name
    linkedin_database: your_schema_name 
```

Additionally, the package allows users to select whether they want to add in costs in USD or the local currency of the ad. By default, the package used USD. If you would like to have costs in the local language, add the following variable to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    linkedin__use_local_currency: True
```


## Contributions

Additional contributions to this package are very welcome! Please create issues
or open PRs against `master`. Check out 
[this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) 
on the best workflow for contributing to a package.

## Resources:
- Learn more about Fivetran [here](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
