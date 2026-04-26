# -------------------------------------------------------------------
# VPC Module
# -------------------------------------------------------------------
module "vpc" {
  source      = "./module/vpc"
  environment = var.environment
}

# -------------------------------------------------------------------
# EC2 Module
# -------------------------------------------------------------------
module "ec2" {
  source        = "./module/ec2"
  subnet_id     = module.vpc.public_subnet_id
  vpc_id        = module.vpc.vpc_id
  instance_type = var.instance_type
  ami_id        = var.ami_id
  environment   = var.environment
}

# -------------------------------------------------------------------
# S3 Module — remote state bucket (versioning + encryption + access block)
# -------------------------------------------------------------------
module "s3" {
  source                = "./module/s3"
  bucket_name           = var.state_bucket_name
  environment           = var.environment
  enable_access_logging = true
}

# -------------------------------------------------------------------
# DynamoDB Module — state locking table
# -------------------------------------------------------------------
module "dynamodb" {
  source      = "./module/dynamodb"
  table_name  = var.lock_table_name
  environment = var.environment
}
