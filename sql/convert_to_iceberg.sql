CREATE TABLE IF NOT EXISTS ds_on_aws_amz_reviews.amazon_reviews_icerberg
WITH (
  format = 'iceberg',
  external_location = 's3://aws-amz-cust-reviews/amazon-reviews-pds/iceberg'
) AS SELECT * FROM tsv_table;