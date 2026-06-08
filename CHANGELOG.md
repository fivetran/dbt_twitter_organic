# dbt_twitter_organic v1.2.0

[PR #26](https://github.com/fivetran/dbt_twitter_organic/pull/26) includes the following updates:

## Schema/Data Changes (--full-refresh required after upgrading)
**1 total change • 1 possible breaking change**

| Data Model(s) | Change type | Old | New | Notes |
| ------------- | ----------- | --- | --- | ----- |
| All models | `source_relation` column (when using a single Twitter Organic schema) | Empty string (`''`) | `<database>.<schema>` |  |

## Feature Updates
- Introduces the new (recommended) `twitter_organic_sources` variable for more robust union data configuration. The old `twitter_organic_union_schemas` and `twitter_organic_union_databases` variables will still be supported. See the [README](https://github.com/fivetran/dbt_twitter_organic/tree/main#define-database-and-schema-variables) for specific details.

## Under the Hood
- Adds the `fivetran_using_source_casing` variable for case-sensitive destination support. When enabled, downstream transformations respect source casing to ensure consistent results. See the [Additional Configurations](https://github.com/fivetran/dbt_twitter_organic/#source-casing-for-case-sensitive-destinations) section of the README for details.
- Introduces `fivetran_utils.partition_by_source_relation` to conditionally include `source_relation` in partition clauses only when multiple sources are configured.

# dbt_twitter_organic v1.1.0
[PR #20](https://github.com/fivetran/dbt_twitter_organic/pull/20) includes the following updates:

## Features
- Increases the required dbt version upper limit to v3.0.0.

# dbt_twitter_organic v1.0.0

[PR #18](https://github.com/fivetran/dbt_twitter_organic/pull/18) includes the following updates:

## Breaking Changes

### Source Package Consolidation
- Removed the dependency on the `fivetran/twitter_organic_source` package.
  - All functionality from the source package has been merged into this transformation package for improved maintainability and clarity.
  - If you reference `fivetran/twitter_organic_source` in your `packages.yml`, you must remove this dependency to avoid conflicts.
  - Any source overrides referencing the `fivetran/twitter_organic_source` package will also need to be removed or updated to reference this package.
  - Update any twitter_organic_source-scoped variables to be scoped to only under this package. See the [README](https://github.com/fivetran/dbt_twitter_organic/blob/main/README.md#changing-the-build-schema) for how to configure the build schema of staging models.
- As part of the consolidation, vars are no longer used to reference staging models, and only sources are represented by vars. Staging models are now referenced directly with `ref()` in downstream models.

### dbt Fusion Compatibility Updates
- Updated package to maintain compatibility with dbt-core versions both before and after v1.10.6, which introduced a breaking change to multi-argument test syntax (e.g., `unique_combination_of_columns`).
- Temporarily removed unsupported tests to avoid errors and ensure smoother upgrades across different dbt-core versions. These tests will be reintroduced once a safe migration path is available.
  - Removed all `dbt_utils.unique_combination_of_columns` tests.
  - Moved `loaded_at_field: _fivetran_synced` under the `config:` block in `src_twitter_organic.yml`.

## Under the Hood
- Updated conditions in `.github/workflows/auto-release.yml`.
- Added `.github/workflows/generate-docs.yml`.

## Documentation
- Added Quickstart model counts to README. ([#15](https://github.com/fivetran/dbt_twitter_organic/pull/15))
- Corrected references to connectors and connections in the README. ([#15](https://github.com/fivetran/dbt_twitter_organic/pull/15))

# dbt_twitter_organic v0.3.0

## Upstream Breaking Changes 
[PR #12](https://github.com/fivetran/dbt_twitter_organic_source/pull/12) from the upstream `dbt_twitter_organic_source` package includes the following breaking change updates:

- The source defined in the `src_twitter_organic.yml` file has been renamed from `twitter_organic` to `twitter` to align with the default schema name used by the upstream Fivetran connector.
    - If you're referencing sources from this package, please update your source references as needed. See below for the full scope of source changes.

| **New Source Reference** | **Old Source Reference** |
|----------------------------------|----------------------------------|
| `"{{ source('twitter','account_history') }}"` | `"{{ source('twitter_organic','account_history') }}"` |
| `"{{ source('twitter','organic_tweet_report') }}"` | `"{{ source('twitter_organic','organic_tweet_report') }}"` |
| `"{{ source('twitter','tweet') }}"` | `"{{ source('twitter_organic','tweet') }}"` |
| `"{{ source('twitter','twitter_user_history') }}"` | `"{{ source('twitter_organic','twitter_user_history') }}"` |

- The default schema name has been modified from `twitter_organic` to now be `twitter` to more closely align with the default schema name generated by the Fivetran connector. Please be aware if you were leveraging the previous default schema then you will need to update the `twitter_organic_schema` variable accordingly. 
- All identifier variables in the `src_twitter_organic.yml` file have been renamed. If you’re using any of these in your project, please update them accordingly. The changes include: 
    - Prepending `twitter_organic_*` has been updated to `twitter_*` to align with the schema change.
    - The spelling of `*_identifer` has been corrected to `*_identifier`.

| **New Identifier Variable Name** | **Old Identifier Variable Name** |
|----------------------------------|----------------------------------|
| `twitter_account_history_identifier` | `twitter_organic_account_history_identifer` |
| `twitter_organic_tweet_report_identifier` | `twitter_organic_organic_tweet_report_identifer` |
| `twitter_tweet_identifier` | `twitter_organic_tweet_identifer` |
| `twitter_twitter_user_history_identifier` | `twitter_organic_twitter_user_history_identifer` |

## Bug Fixes
- Updated the `is_most_recent_record` window function in the following models to exclude the `source_relation` field from the partition statement when `twitter_organic_union_schemas` or `twitter_organic_union_databases` variables are empty. Also, modified it to skip the window function if the upstream table is empty, using the new `window_function_if_table_exists()` and `is_table_empty()` macros. This change addresses Redshift's issue with partitioning by constant expressions. ([PR #11](https://github.com/fivetran/dbt_twitter_organic/pull/11))
    - `int_twitter_organic__latest_account`
    - `int_twitter_organic__latest_user`

## Under the Hood
- Included auto-releaser GitHub Actions workflow to automate future releases. 
- Consistency validations for integration tests has been added for the `twitter_organic__tweets` model. ([PR #11](https://github.com/fivetran/dbt_twitter_organic/pull/11))
- Renamed the seed files to allow for more testing functionality. ([PR #11](https://github.com/fivetran/dbt_twitter_organic/pull/11))
- Updated the maintainer PR, Issue, Feature Request, and Config templates to resemble the most up to date format. ([PR #11](https://github.com/fivetran/dbt_twitter_organic/pull/11))
- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job. ([#7](https://github.com/fivetran/dbt_twitter_organic/pull/7))

# dbt_twitter_organic v0.2.0

## 🚨 Breaking Changes 🚨:
[PR #5](https://github.com/fivetran/dbt_twitter_organic/pull/5) includes the following breaking changes:
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
- Dependencies on `fivetran/fivetran_utils` have been upgraded, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.

# dbt_twitter_organic v0.1.0

The original release! The main focus of the package is to transform the core social media object tables into analytics-ready models that can be easily unioned in to other social media platform packages to get a single view. This is especially easy using our [Social Media Reporting package](https://github.com/fivetran/dbt_social_media_reporting).