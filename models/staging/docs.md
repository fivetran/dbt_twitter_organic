{% docs _fivetran_synced -%} When the record was last synced by Fivetran. {%- enddocs %}

{% docs is_most_recent_record %} Boolean representing whether a record is the most recent version of that record. All records should have this value set to True given we filter on it. {% enddocs %}

{% docs coordinates_coordinates -%} The longitude and latitude of the location attached to the tweet, as a GeoJSON coordinate pair in [longitude, latitude] order. Null unless the user shared an exact location. {%- enddocs %}

{% docs coordinates_type -%} The GeoJSON geometry type of the location attached to the tweet, such as 'Point'. {%- enddocs %}

{% docs geo_coordinates -%} Deprecated by Twitter in favor of `coordinates_coordinates`. The latitude and longitude of the location attached to the tweet, in the reverse order of the GeoJSON coordinate pair. {%- enddocs %}

{% docs geo_type -%} Deprecated by Twitter in favor of `coordinates_type`. The geometry type of the location attached to the tweet, such as 'Point'. {%- enddocs %}

{% docs placement -%} The placement the metrics were measured for, such as 'ALL_ON_TWITTER' or 'PUBLISHER_NETWORK'. {%- enddocs %}

{% docs tweets_send -%} Number of tweets sent. {%- enddocs %}
