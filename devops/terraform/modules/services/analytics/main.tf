# Module to create the Analytics Lambda function
# Inputs:

resource "aws_iam_role" "lambda_exec_role" {
  name                = "lambda-diverst-analytics-exec-role"
  assume_role_policy  = file("${path.module}/policies/assume_policy.json")
}

resource "aws_iam_policy" "cloudwatch_policy" {
  name    = "lambda-analytics-cloudwatch-policy"
  policy  = file("${path.module}/policies/cloudwatch_policy.json")
}

resource "aws_iam_policy" "vpc_policy" {
  name    = "lambda-analytics-vpc-policy"
  policy  = file("${path.module}/policies/vpc_policy.json")
}

resource "aws_iam_policy" "s3_policy" {
  name    = "lambda-analytics-s3-policy"
  policy  = file("${path.module}/policies/s3_policy.json")
}

resource "aws_iam_role_policy_attachment" "cloudwatch_policy_attachment" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.cloudwatch_policy.arn
}

resource "aws_iam_role_policy_attachment" "vpc_policy_attachment" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.vpc_policy.arn
}

resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_lambda_function" "diverst_analytics" {
  function_name = "diverst-analytics"

  s3_bucket = "devops-inmvlike"
  s3_key    = "deploy.zip"

  handler   = "main.main"
  runtime   = "ruby2.7"
  role      = aws_iam_role.lambda_exec_role.arn

  vpc_config {
    subnet_ids          = var.sn_db.*.id
    security_group_ids  = [var.sg_db.id]
  }
}

