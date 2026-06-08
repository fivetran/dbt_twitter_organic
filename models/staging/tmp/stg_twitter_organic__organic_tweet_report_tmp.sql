{% if var('twitter_organic_union_schemas', []) | length > 0 or var('twitter_organic_union_databases', []) | length > 0 %}

{{
    fivetran_utils.union_data(
        table_identifier='organic_tweet_report', 
        database_variable='twitter_organic_database', 
        schema_variable='twitter_organic_schema', 
        default_database=target.database,
        default_schema='twitter',
        default_variable='organic_tweet_report',
        union_schema_variable='twitter_organic_union_schemas',
        union_database_variable='twitter_organic_union_databases'
    )
}}

{% else %}

{{
    fivetran_utils.union_connections(
        connection_dictionary='twitter_organic_sources',
        single_source_name='twitter_organic',
        single_table_name='organic_tweet_report'
    )
}}

{% endif %}