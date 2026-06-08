<!--section="twitter-organic_transformation_model"-->
# Twitter Organic dbt Package

This dbt package transforms data from Fivetran's Twitter Organic connector into analytics-ready tables.

## Resources

- Number of materialized models¹: 11
- Connector documentation
  - [Twitter Organic connector documentation](https://fivetran.com/docs/connectors/applications/twitter)
  - [Twitter Organic ERD](https://docs.google.com/presentation/d/1gNGe510SGyMJsuATCjjTuNrik0y8EgDOHJcZKKd165E/edit?usp=sharing)
- dbt package documentation
  - [GitHub repository](https://github.com/fivetran/dbt_twitter_organic)
  - [dbt Docs](https://fivetran.github.io/dbt_twitter_organic/#!/overview)
  - [DAG](https://fivetran.github.io/dbt_twitter_organic/#!/overview?g_v=1)
  - [Changelog](https://github.com/fivetran/dbt_twitter_organic/blob/main/CHANGELOG.md)
- dbt Core™ supported versions
  - `>=1.3.0, <3.0.0`

## What does this dbt package do?
This package enables you to transform core social media object tables into analytics-ready models that can be easily unioned with other social media platform packages. It creates enriched models with metrics focused on tweet performance and social media analytics.

The main focus of the package is to transform the core social media object tables into analytics-ready models that can be easily unioned in to other social media platform packages to get a single view. This is aided by our [Social Media Reporting package](https://github.com/fivetran/dbt_social_media_reporting).

### Output schema
Final output tables are generated in the following target schema:

```
<your_database>.<connector/schema_name>_twitter_organic
```

### Final output tables

By default, this package materializes the following final tables:

| Table | Description |
| :---- | :---- |
| [twitter_organic__tweets](https://fivetran.github.io/dbt_twitter_organic/#!/model/model.twitter_organic.twitter_organic__tweets) | Tracks daily performance metrics for your organic tweets to measure engagement, reach, and audience interaction patterns on Twitter/X. <br></br>**Example Analytics Questions:**<ul><li>Which tweets generate the highest engagement rates (likes, retweets, replies) by content type or hashtag?</li><li>How does tweet performance vary by day of week or time of posting?</li><li>What types of content drive the most impressions and profile visits?</li></ul>|

¹ Each Quickstart transformation job run materializes these models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`.

---

## Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Twitter Organic connection syncing data into your destination.
- A BigQuery, Snowflake, Redshift, PostgreSQL, or Databricks destination.

## How do I use the dbt package?
You can either add this dbt package in the Fivetran dashboard or import it into your dbt project:

- To add the package in the Fivetran dashboard, follow our [Quickstart guide](https://fivetran.com/docs/transformations/data-models/quickstart-management).
- To add the package to your dbt project, follow the setup instructions in the dbt package's [README file](https://github.com/fivetran/dbt_twitter_organic/blob/main/README.md#how-do-i-use-the-dbt-package) to use this package.

<!--section-end-->

### Installing the Package
Include the following Twitter Organic package version in your `packages.yml`
> Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

```yaml
packages:
  - package: fivetran/twitter_organic
    version: [">=1.2.0", "<1.3.0"] # we recommend using ranges to capture non-breaking changes automatically
```
> All required sources and staging models are now bundled into this transformation package. Do not include `fivetran/twitter_organic_source` in your `packages.yml` since this package has been deprecated.

#### Databricks Additional Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your root `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

### Configure Your Variables

### Define database and schema variables
#### Option A: Single connection
By default, this package runs using your destination and the `twitter_organic` schema. If this is not where your Twitter Organic data is (for example, if your Twitter Organic schema is named `twitter_organic_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
    twitter_organic_database: your_destination_name
    twitter_organic_schema: your_schema_name
```

#### Option B: Union multiple connections
If you have multiple Twitter Organic connections in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. For each source table, the package will union all of the data together and pass the unioned table into the transformations. The `source_relation` column in each model indicates the origin of each record.

To use this functionality, you will need to set the `twitter_organic_sources` variable in your root `dbt_project.yml` file:

```yml
# dbt_project.yml

vars:
  twitter_organic:
    twitter_organic_sources:
      - database: connection_1_destination_name # Required
        schema: connection_1_schema_name # Required
        name: connection_1_source_name # Required only if following the step in the following subsection

      - database: connection_2_destination_name
        schema: connection_2_schema_name
        name: connection_2_source_name
```

> Previous versions of this package employed two separate, mutually exclusive variables for unioning: `twitter_organic_union_schemas` and `twitter_organic_union_databases`. While these variables are still supported, `twitter_organic_sources` is the recommended variable to configure.

#### Optional: Incorporate unioned sources into DAG

If you use [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt#transformationsfordbtcore) and are unioning multiple Twitter Organic connections, you can define your sources in a property `.yml` file, [using this as a template](https://github.com/fivetran/dbt_twitter_organic/blob/main/models/staging/src_twitter_organic.yml). Set the variable `has_defined_sources: true` under the Twitter Organic namespace in your `dbt_project.yml`. Otherwise, your Twitter Organic connections won't appear in your DAG. See the `union_connections` macro [documentation](https://github.com/fivetran/dbt_fivetran_utils/tree/releases/v0.4.latest#optional-union-connections-defined-sources-configuration) for full configuration details.

### (Optional) Additional Configurations
<details open><summary>Expand for configurations</summary>

#### Change the Build Schema
By default, this package builds the Twitter Organic staging models within a schema titled (<target_schema> + `_stg_twitter_organic`) and the Twitter Organic end models in a schema titled (<target_schema> + `twitter_organic`) in your target database. If this is not where you would like your Twitter Organic data to be written to, add the following configuration to your root `dbt_project.yml` file:

```yml 
models:
    twitter_organic:
      +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
      staging:
        +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
```

#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:
> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_twitter_organic/blob/main/dbt_project.yml) variable declarations to see the expected names.

```yml
vars:
    twitter_<default_source_table_name>_identifier: your_table_name 
```

#### Source casing for case-sensitive destinations
By default, the package applies case-insensitive comparisons when resolving `source_relation` values. If your destination is case-sensitive and you want downstream transformations to respect the exact casing of your source database and schema names, set the following variable:

```yml
vars:
    fivetran_using_source_casing: true
```
</details>

### (Optional) Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for configurations</summary>
<br>
Fivetran offers the ability for you to orchestrate your dbt project through the [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt#transformationsfordbtcore) product. Refer to the linked docs for more information on how to setup your project for orchestration through Fivetran.
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

<!--section="twitter-organic_maintenance"-->
## How is this package maintained and can I contribute?

### Package Maintenance
The Fivetran team maintaining this package only maintains the [latest version](https://hub.getdbt.com/fivetran/twitter_organic/latest/) of the package. We highly recommend you stay consistent with the latest version of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_twitter_organic/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Learn how to contribute to a package in dbt's [Contributing to an external dbt package article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657).

<!--section-end-->

## Are there any resources available?
- If you encounter any questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_twitter_organic/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran, or would like to request a future dbt package to be developed, then feel free to fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).