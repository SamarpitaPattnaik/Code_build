output "bucket_name" {
  description = "Name of the Terraform state S3 bucket"
  value       = aws_s3_bucket.state_bucket.bucket
}

output "bucket_arn" {
  description = "ARN of the Terraform state S3 bucket"
  value       = aws_s3_bucket.state_bucket.arn
}

output "bucket_id" {
  description = "ID of the Terraform state S3 bucket"
  value       = aws_s3_bucket.state_bucket.id
}
