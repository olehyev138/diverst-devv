resource "random_string" "bucket-postfix" {
  length  = 8
  special = false
  number  = false
  upper   = false
}

resource "aws_s3_bucket" "bucket-frontend" {
  bucket  = "${var.env_name}-frontend-${random_string.bucket-postfix.result}"
  policy  = templatefile("${path.module}/policy.tmpl", { client_name = "${var.env_name}-frontend-${random_string.bucket-postfix.result}" })
  acl     = "public-read"

  website {
    index_document = "index.html"
  }
}
