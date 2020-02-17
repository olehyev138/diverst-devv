output frontend_endpoint {
  value = aws_s3_bucket.bucket-frontend.website_endpoint
}

output frontend_bucket {
  value = aws_s3_bucket.bucket-frontend.id
}
