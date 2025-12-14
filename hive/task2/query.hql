set hive.cli.print.header=false;

USE ${hiveconf:db_name};

CREATE EXTERNAL TABLE IF NOT EXISTS business_raw(line STRING)
STORED AS TEXTFILE
LOCATION '/data/yelp/business';

ADD FILE mapper.py;

WITH tags AS (
  SELECT
    t.business_id as business_id,
    t.tag as tag
  FROM (
    SELECT TRANSFORM(line)
    USING 'python3 mapper.py'
    AS (business_id STRING, tag STRING)
    FROM business_raw
  ) t
)
SELECT
  tag,
  COUNT(DISTINCT business_id) AS cnt
FROM tags
GROUP BY tag
ORDER BY tag;
