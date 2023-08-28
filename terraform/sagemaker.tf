resource "aws_sagemaker_domain" "domain" {
  domain_name = "ds-on-aws"
  auth_mode   = "IAM"
  vpc_id      = aws_vpc.main.id
  subnet_ids  = [aws_subnet.public_a.id]

  default_user_settings {
    execution_role = var.sagemaker_role
  }

}

resource "aws_sagemaker_user_profile" "user_profile" {
  domain_id         = aws_sagemaker_domain.domain.id
  user_profile_name = local.prefix
}


resource "aws_sagemaker_code_repository" "repo" {
  code_repository_name = "ds-on-aws"

  git_config {
    repository_url = "https://github.com/priyanshu124/aws-ds"
  }
}

resource "aws_sagemaker_notebook_instance" "notebook" {
  name                    = "ds-on-aws"
  role_arn                = var.sagemaker_role
  instance_type           = "ml.t2.medium"
  default_code_repository = aws_sagemaker_code_repository.repo.code_repository_name
}