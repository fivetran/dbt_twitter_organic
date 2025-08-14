with users as (

    select *
    from {{ ref('stg_twitter_organic__twitter_user_history') }}

), is_most_recent as (

    select 
        *,
        {{ twitter_organic.result_if_table_exists(
            table_ref=ref('stg_twitter_organic__twitter_user_history'), 
            result_statement='row_number() over (partition by user_id' ~ (', source_relation' if var('twitter_organic_union_schemas', []) or var('twitter_organic_union_databases', []) | length > 1) ~ ' order by _fivetran_synced desc)',
            if_empty=1
        )}} = 1 as is_most_recent_record
    from users

)

select *
from is_most_recent