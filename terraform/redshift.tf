resource "aws_iam_role" "redshift_role" {
  name = "redshift_role"
  tags = {
    name = "redshift-role"
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "redshift.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF



}


resource "aws_security_group" "redshift_security_group" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "redshift-sg"
  }
}


resource "aws_iam_role_policy" "redshift_role_policy" {
  name   = "redshift_role_policy"
  role   = aws_iam_role.redshift_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "redshift:*"
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
        "arn:aws:s3:::aws-amz-cust-reviews/*",
        "arn:aws:s3:::ds-on-aws-dev-athena-query-result",
        "arn:aws:s3:::ds-on-aws-dev-athena-query-result/*"


      ]
    },
    {
        "Effect": "Allow",
        "Action": [
            "glue:*",
            "lakeformation:GetDataAccess"
        ],
        "Resource": "*"
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

resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "redshift-subnet-group"
  subnet_ids = ["${aws_subnet.private_a.id}", "${aws_subnet.private_b.id}"]

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}-redshift-subnet-group" }
  )

}

resource "aws_redshift_cluster" "redshift" {
  cluster_identifier        = "ds-dwh"
  database_name             = "amazon_reviews"
  master_username           = "exampleuser"
  master_password           = "Mustbe8characters"
  node_type                 = "dc2.large"
  cluster_type              = "single-node"
  iam_roles                 = ["${aws_iam_role.redshift_role.arn}"]
  vpc_security_group_ids    = ["${aws_security_group.redshift_security_group.id}"]
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.id
}