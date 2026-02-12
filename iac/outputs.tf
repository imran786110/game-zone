output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.game_zone.id
}

output "s3_website_endpoint" {
  description = "S3 website endpoint"
  value       = aws_s3_bucket_website_configuration.game_zone.website_endpoint
}

output "cloudfront_domain" {
  description = "CloudFront distribution domain"
  value       = aws_cloudfront_distribution.game_zone.domain_name
}

output "cloudfront_url" {
  description = "CloudFront URL"
  value       = "https://${aws_cloudfront_distribution.game_zone.domain_name}"
}
