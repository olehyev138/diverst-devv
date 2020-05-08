# Module for Diverst Analytics service
#   - creates:
#       - a Lambda function to compute metrics
#       - a S3 bucket for storing computed JSON data
#       - CloudWatch Alarm to run function on configured interval
#   - runs in database subnet & uses database security group
# Inputs:
#  - env_name: environment name
#  - sn_db: database subnet
#  - sg_db: database security group
#  - interval: string describing interval to run analytics rule on, should be in form:
#      "<number> <minutes|hours>"

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
  function_name = "${var.env_name}-diverst-analytics"

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

#
## S3 bucket for storing metrics data, named in format: <env-name>-diverst-analytics
#

resource "aws_s3_bucket" "bucket-filestorage" {
  bucket        = "${var.env_name}-diverst-analytics"
  force_destroy = true
}

#
## Cloudwatch resources to invoke function on interval
#

resource "aws_cloudwatch_event_rule" "analytics_invoke_rule" {
  name                  = "analytics_invoke_rule"
  description           = "Runs analytics function on configured interval"
  schedule_expression   = "rate(${var.interval})"
}

resource "aws_cloudwatch_event_target" "analytics_invoke_rule_target" {
  rule        = aws_cloudwatch_event_rule.analytics_invoke_rule.name
  target_id   = "lambda"
  arn         = aws_lambda_function.diverst_analytics.arn

  input       = jsonencode({"env_name"=var.env_name})
}

resource "aws_lambda_permission" "analytics_invoke_rule_permission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.diverst_analytics.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.analytics_invoke_rule.arn
}
