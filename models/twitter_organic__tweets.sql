with account_history as (

    select *
    from {{ var('account_history') }}
    where is_most_recent_record = True

),

organic_tweet_report as (

    select *
    from {{ var('organic_tweet_report') }}

),

tweet as (

    select *
    from {{ var('tweet') }}

), 

joined as (

    select
        tweet.created_timestamp,
        tweet.organic_tweet_id,
        tweet.tweet_text,
        tweet.account_id,
        account_history.account_name,
        organic_tweet_report.date_day,
        sum(organic_tweet_report.app_clicks) as app_clicks,
        sum(organic_tweet_report.card_engagements) as card_engagements,
        sum(organic_tweet_report.carousel_swipes) as carousel_swipes,
        sum(organic_tweet_report.clicks) as clicks,
        sum(organic_tweet_report.engagements) as engagements,
        sum(organic_tweet_report.follows) as follows,
        sum(organic_tweet_report.impressions) as impressions,
        sum(organic_tweet_report.likes) as likes,
        sum(organic_tweet_report.poll_card_vote) as poll_card_vote,
        sum(organic_tweet_report.qualified_impressions) as qualified_impressions,
        sum(organic_tweet_report.replies) as replies,
        sum(organic_tweet_report.retweets) as retweets,
        sum(organic_tweet_report.tweets_send) as tweets_send,
        sum(organic_tweet_report.unfollows) as unfollows,
        sum(organic_tweet_report.url_clicks) as url_clicks,
        sum(organic_tweet_report.video_15_s_views) as video_15_s_views,
        sum(organic_tweet_report.video_3_s_100_pct_views) as video_3_s_100_pct_views,
        sum(organic_tweet_report.video_6_s_views) as video_6_s_views,
        sum(organic_tweet_report.video_content_starts) as video_content_starts,
        sum(organic_tweet_report.video_cta_clicks) as video_cta_clicks,
        sum(organic_tweet_report.video_total_views) as video_total_views,
        sum(organic_tweet_report.video_views_100) as video_views_100,
        sum(organic_tweet_report.video_views_25) as video_views_25,
        sum(organic_tweet_report.video_views_50) as video_views_50,
        sum(organic_tweet_report.video_views_75) as video_views_75
    from tweet
    left join account_history
        on tweet.account_id = account_history.account_id
    left join organic_tweet_report
        on tweet.organic_tweet_id = organic_tweet_report.organic_tweet_id
    {{ dbt_utils.group_by(6) }}

)

select *
from joined