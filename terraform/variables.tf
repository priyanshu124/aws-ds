variable "prefix" {
  default = "ds-on-aws"
}


variable "project" {
  default = "ds-on-aws"
}

variable "contact" {
  default = "priyanshu.gupta"
}

variable "region" {
  default = "us-east-1"
}

variable "sagemaker_role" {
  default = "arn:aws:iam::362838946998:role/sagemaker_role"
}

variable "sql_path" {
  default = "/aws-ds/sql"
}


variable "s3_reviews_bucket" {
  default = "aws-amz-cust-reviews"
}

variable "s3_reviews_folder" {
  default = "amazon-reviews-pds"
}
