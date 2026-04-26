variable "bucket_name" {
  description = "Name of the S3 bucket for Terraform remote state"
  type        = string
  default     = "terraform-state-333982363626-ap-south-1-an"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "enable_access_logging" {
  description = "Enable S3 server access logging"
  type        = bool
  default     = true
}
