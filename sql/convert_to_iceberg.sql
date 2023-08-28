CREATE TABLE IF NOT EXISTS ds_on_aws_amz_reviews.amazon_reviews_iceberg
( 
 marketplace string,
 customer_id string,
 review_id string,
 product_id string,
 product_parent string,
 product_title string,
 star_rating int,
 helpful_votes int ,
 total_votes int,
 vine string,
 verified_purchase string,
 review_headline string,
 review_body string,
 year int ,
 review_date date,
 product_category string
)
PARTITIONED BY (product_category)
LOCATION 's3://aws-amz-cust-reviews/amazon-reviews-pds/iceberg/'
TBLPROPERTIES ( 'table_type' ='ICEBERG' );


INSERT INTO ds_on_aws_amz_reviews.amazon_reviews_iceberg
SELECT 
 marketplace,
 customer_id,
 review_id,
 product_id,
 product_parent,
 product_title,
 star_rating,
 helpful_votes,
 total_votes,
 vine,
 verified_purchase,
 review_headline,
 review_body,
 CAST(YEAR(DATE(review_date)) AS INTEGER) AS year,
 DATE(review_date) AS review_date,
 product_category
FROM ds_on_aws_amz_reviews.amazon_reviews_tsv ;