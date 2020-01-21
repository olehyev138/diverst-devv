# S3 Bucket for user/client filestorage functionality

resource "random_string" "bucket-postfix" {
  length  = 8
  special = false
  number  = false
  upper   = false
}

resource "aws_s3_bucket" "bucket-filestorage" {
  bucket        = "${var.env_name}-filestorage-${random_string.bucket-postfix.result}"
  force_destroy = true
}
