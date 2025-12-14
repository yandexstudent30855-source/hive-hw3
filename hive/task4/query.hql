set hive.cli.print.header=false;

USE ${hiveconf:db_name};

CREATE EXTERNAL TABLE IF NOT EXISTS business_raw(line STRING)
STORED AS TEXTFILE
LOCATION '/data/yelp/business';

ADD FILE mapper.py;

SELECT
  business_id,
  open_hours
FROM (
  SELECT TRANSFORM(line)
  USING 'python3 mapper.py'
  AS (business_id STRING, open_hours DOUBLE)
  FROM business_raw
) t;
