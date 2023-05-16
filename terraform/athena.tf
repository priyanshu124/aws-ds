
// Globally unique S3 bucket for Athena to store query results
resource "aws_s3_bucket" "athena_query_result_bucket" {
  bucket        = "${local.prefix}-athena-query-result"
  force_destroy = true
  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}-athena-query-result" }
  )
}

// Athena Database
resource "aws_athena_database" "ds_on_aws_amz_reviews" {
  name   = "ds_on_aws_amz_reviews"
  bucket = aws_s3_bucket.athena_query_result_bucket.id
}

// Athena Workgroup
resource "aws_athena_workgroup" "athena-dev" {
  name          = "athena-dev"
  description   = "Athena Workgroup for developement"
  force_destroy = true
  configuration {
    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena_query_result_bucket.id}"
    }
  }
}