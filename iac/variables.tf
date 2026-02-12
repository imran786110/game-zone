variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "S3 bucket name for game zone"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "game-zone"
}

variable "cognito_domain" {
  description = "Cognito domain prefix (must be globally unique)"
  type        = string
}
