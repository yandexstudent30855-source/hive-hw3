set hive.cli.print.header=false;

USE ${hiveconf:db_name};

-- raw таблицы на JSON строки
CREATE EXTERNAL TABLE IF NOT EXISTS business_raw(line STRING)
STORED AS TEXTFILE
LOCATION '/data/yelp/business';

CREATE EXTERNAL TABLE IF NOT EXISTS review_raw(line STRING)
STORED AS TEXTFILE
LOCATION '/data/yelp/review';

WITH business_city AS (
  SELECT
    get_json_object(line, '$.business_id') AS business_id,
    get_json_object(line, '$.city')        AS city,
    get_json_object(line, '$.categories')  AS categories
  FROM business_raw
  WHERE get_json_object(line, '$.business_id') IS NOT NULL
),
neg_reviews AS (
  SELECT
    get_json_object(line, '$.business_id') AS business_id,
    CAST(get_json_object(line, '$.stars') AS DOUBLE) AS stars
  FROM review_raw
  WHERE get_json_object(line, '$.business_id') IS NOT NULL
),
agg AS (
  SELECT
    b.city AS city,
    r.business_id AS business_id,
    COUNT(1) AS negative_reviews
  FROM neg_reviews r
  JOIN business_city b
    ON r.business_id = b.business_id
  WHERE r.stars < 3
    AND b.categories LIKE '%Restaurants%'
    AND b.city IS NOT NULL
  GROUP BY b.city, r.business_id
),
ranked AS (
  SELECT
    business_id,
    city,
    negative_reviews,
    ROW_NUMBER() OVER (
      PARTITION BY city
      ORDER BY negative_reviews DESC, business_id ASC
    ) AS rn
  FROM agg
)
SELECT
  business_id,
  city,
  negative_reviews
FROM ranked
WHERE rn <= 10
ORDER BY city, rn;
