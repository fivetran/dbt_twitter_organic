with users as (

    select *
    from {{ var('users_staging') }}

), is_most_recent as (

    select 
        *,
        row_number() over (partition by user_id, source_relation order by _fivetran_synced desc) = 1 as is_most_recent_record
    from users

)

select *
from is_most_recent