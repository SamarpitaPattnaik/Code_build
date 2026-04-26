resource "aws_s3_bucket" "state_bucket" {
  bucket        = var.bucket_name
  force_destroy = false

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Enable versioning so every state file revision is retained
resource "aws_s3_bucket_versioning" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Server-side encryption (AES-256)
resource "aws_s3_bucket_server_side_encryption_configuration" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Block ALL public access — state files must never be public
resource "aws_s3_bucket_public_access_block" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Access logging bucket (optional)
resource "aws_s3_bucket" "log_bucket" {
  count         = var.enable_access_logging ? 1 : 0
  bucket        = "${var.bucket_name}-logs"
  force_destroy = true

  tags = {
    Name        = "${var.bucket_name}-logs"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_public_access_block" "log_bucket" {
  count  = var.enable_access_logging ? 1 : 0
  bucket = aws_s3_bucket.log_bucket[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "state_bucket" {
  count         = var.enable_access_logging ? 1 : 0
  bucket        = aws_s3_bucket.state_bucket.id
  target_bucket = aws_s3_bucket.log_bucket[0].id
  target_prefix = "state-access-logs/"
}

# Lifecycle policy — expire non-current versions after 90 days
resource "aws_s3_bucket_lifecycle_configuration" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.id

  rule {
    id     = "expire-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
