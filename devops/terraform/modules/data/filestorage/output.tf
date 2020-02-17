output "filestorage_bucket_id" {
  value         = aws_s3_bucket.bucket-filestorage.id
  description   = "Name/Id of bucket for filestorage"
}

