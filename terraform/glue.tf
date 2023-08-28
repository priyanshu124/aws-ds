resource "aws_iam_role" "glue_crawler_role" {
  name = "analytics_glue_crawler_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "glue_crawler_role_policy" {
  name   = "analytics_glue_crawler_role_policy"
  role   = aws_iam_role.glue_crawler_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "glue:*"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetBucketLocation",
        "s3:ListBucket",
        "s3:GetBucketAcl",
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::aws-amz-cust-reviews",
        "arn:aws:s3:::aws-amz-cust-reviews/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:*:*:/aws-glue/*"
      ]
    }
  ]
}
EOF
}


resource "aws_glue_crawler" "reviews_crawler" {
  database_name = aws_athena_database.ds_on_aws_amz_reviews.name
  name          = "amz_reviews_crawler_tsv"
  role          = aws_iam_role.glue_crawler_role.arn

  schedule = "cron(59 23 * * ? *)"
  
  schema_change_policy {
        delete_behavior = "LOG"
    }

  s3_target {
    path = "s3://${var.s3_reviews_bucket}/${var.s3_reviews_folder}/tsv"
  }
}
