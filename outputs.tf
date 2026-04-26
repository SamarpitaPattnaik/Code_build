output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = module.vpc.public_subnet_id
}

output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "EC2 Public IP"
  value       = module.ec2.public_ip
}

output "state_bucket_name" {
  description = "Terraform state S3 bucket name"
  value       = module.s3.bucket_name
}

output "state_bucket_arn" {
  description = "Terraform state S3 bucket ARN"
  value       = module.s3.bucket_arn
}

output "dynamodb_table_name" {
  description = "DynamoDB lock table name"
  value       = module.dynamodb.dynamodb_table_name
}

output "dynamodb_table_arn" {
  description = "DynamoDB lock table ARN"
  value       = module.dynamodb.dynamodb_table_arn
}
