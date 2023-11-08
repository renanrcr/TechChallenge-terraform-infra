output "bucket_name" {
  description = "S3 Bucket Outputs"
  value = aws_s3_bucket.lambda_auth.bucket
}