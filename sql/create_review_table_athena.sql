CREATE EXTERNAL TABLE IF NOT EXISTS ds_on_aws_amz_reviews.amazon_reviews_tsv(
    marketplace string,
    customer_id string,
    review_id string,
    product_id string,
    product_parent string,
    product_title string,
    product_category string,
    star_rating int,
    helpful_votes int,
    total_votes int,
    vine string,
    verified_purchase string,
    review_headline string,
    review_body string,
    review_date string
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
LOCATION 's3://aws-amz-cust-reviews/amazon-reviews-pds/'
TBLPROPERTIES ('compressionType' = 'gzip', 'skip.header.line.count' = '1')