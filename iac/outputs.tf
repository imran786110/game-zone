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

output "api_endpoint" {
  description = "API Gateway endpoint"
  value       = aws_apigatewayv2_stage.prod.invoke_url
}

output "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  value       = aws_cognito_user_pool.game_zone.id
}

output "cognito_client_id" {
  description = "Cognito Client ID"
  value       = aws_cognito_user_pool_client.game_zone.id
}

output "cognito_domain" {
  description = "Cognito domain"
  value       = "https://${aws_cognito_user_pool_domain.game_zone.domain}.auth.${var.aws_region}.amazoncognito.com"
}

output "user_profiles_table" {
  description = "DynamoDB User Profiles table"
  value       = aws_dynamodb_table.user_profiles.name
}

output "game_scores_table" {
  description = "DynamoDB Game Scores table"
  value       = aws_dynamodb_table.game_scores.name
}
