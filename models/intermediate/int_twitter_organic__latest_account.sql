with accounts as (

    select *
    from {{ var('account_history_staging') }}

), is_most_recent as (

    select 
        *,
        row_number() over (partition by account_id, source_relation order by _fivetran_synced desc) = 1 as is_most_recent_record
    from accounts

)

select *
from is_most_recent