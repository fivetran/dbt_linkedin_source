## Best Practices with Configuring LinkedIn Ads Conversion Fields Variable
The `linkedin_ads__conversion_fields` variable is designed for end users to properly measure the conversions at the proper level of granularity. By default, we use `external_website_conversions` and `one_click_leads` as they are arguably the most used conversion measures, and fulfill entirely separate objectives as conversions (Website Conversion and Lead Generation respectively). 

However, if you decide to configure your own conversion field variable fields, we highly recommend that you bring in conversions at the proper level of segmentation, so there aren't conversions that belong to multiple fields you bring in.

### Bad Practice Example

```yml
# dbt_project.yml
vars:
    linkedin_ads__conversion_fields: ['external_website_conversions', 'external_website_pre_click_conversions', 'external_website_post_click_conversions']
```

`external_website_conversions` is comprised of both `external_website_pre_click_conversions` and `external_website_post_click_conversions`. 

### Good Practice Example

```yml
# dbt_project.yml
vars:
    linkedin_ads__conversion_fields: ['external_website_pre_click_conversions', 'external_website_post_click_conversions']
```

`external_website_pre_click_conversions` and `external_website_post_click_conversions` are two different type of external website conversions, so there should be no overlap. 