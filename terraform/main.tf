terraform {
  backend "s3" {
    bucket         = "data-engg-tf-state"
    key            = "data-engg.tf-state"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "data-engg-tf-state-lock"
  }
}

provider "aws" {
  region  = "us-east-1"
  version = "~> 4.0"
}


locals {
  prefix = "${var.prefix}-${terraform.workspace}"
  common_tags = {
    Environment = terraform.workspace
    Project     = var.project
    Owner       = var.contact
    ManagedBy   = "Terraform"
  }
}