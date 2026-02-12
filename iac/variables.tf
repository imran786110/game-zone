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

variable "cloudfront_url" {
  description = "CloudFront URL for OAuth callbacks"
  type        = string
  default     = "https://d14uok7hn0kap5.cloudfront.net"
}

variable "enable_google_login" {
  description = "Enable Google OAuth login"
  type        = bool
  default     = false
}

variable "google_client_id" {
  description = "Google OAuth client ID"
  type        = string
  default     = ""
  sensitive   = true
}

variable "google_client_secret" {
  description = "Google OAuth client secret"
  type        = string
  default     = ""
  sensitive   = true
}

variable "enable_github_login" {
  description = "Enable GitHub OAuth login"
  type        = bool
  default     = false
}

variable "github_client_id" {
  description = "GitHub OAuth client ID"
  type        = string
  default     = ""
  sensitive   = true
}

variable "github_client_secret" {
  description = "GitHub OAuth client secret"
  type        = string
  default     = ""
  sensitive   = true
}
