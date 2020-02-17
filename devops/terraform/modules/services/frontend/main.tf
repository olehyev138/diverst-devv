resource "aws_s3_bucket" "bucket-frontend" {
  bucket        = "${var.env_name}.diverst.com"
  acl           = "public-read"
  force_destroy = true
  policy        = templatefile("${path.module}/policy.tmpl", { bucket_name = "${var.env_name}.diverst.com" })

  website {
    index_document  = "index.html"
    routing_rules   = templatefile("${path.module}/routing.tmpl", {})
  }
}
