resource "aws_cognito_user_pool" "game_zone" {
  name = "${var.project_name}-user-pool"

  auto_verified_attributes = ["email"]
  username_attributes      = ["email"]

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
    require_uppercase = true
  }

  schema {
    name                = "email"
    attribute_data_type = "String"
    required            = true
    mutable             = false
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
}

resource "aws_cognito_user_pool_client" "game_zone" {
  name         = "${var.project_name}-client"
  user_pool_id = aws_cognito_user_pool.game_zone.id

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]

  prevent_user_existence_errors = "ENABLED"

  supported_identity_providers = concat(
    ["COGNITO"],
    var.enable_google_login ? ["Google"] : [],
    var.enable_github_login ? ["GitHub"] : []
  )

  callback_urls = [
    "${var.cloudfront_url}/callback.html",
    "http://localhost:8080/callback.html"
  ]

  logout_urls = [
    var.cloudfront_url,
    "http://localhost:8080"
  ]

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
}

resource "aws_cognito_user_pool_domain" "game_zone" {
  domain       = var.cognito_domain
  user_pool_id = aws_cognito_user_pool.game_zone.id
}

resource "aws_cognito_identity_provider" "google" {
  count         = var.enable_google_login ? 1 : 0
  user_pool_id  = aws_cognito_user_pool.game_zone.id
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    authorize_scopes = "email openid profile"
    client_id        = var.google_client_id
    client_secret    = var.google_client_secret
  }

  attribute_mapping = {
    email    = "email"
    username = "sub"
  }
}

resource "aws_cognito_identity_provider" "github" {
  count         = var.enable_github_login ? 1 : 0
  user_pool_id  = aws_cognito_user_pool.game_zone.id
  provider_name = "GitHub"
  provider_type = "OIDC"

  provider_details = {
    authorize_scopes              = "user:email"
    client_id                     = var.github_client_id
    client_secret                 = var.github_client_secret
    attributes_request_method     = "GET"
    oidc_issuer                   = "https://token.actions.githubusercontent.com"
    authorize_url                 = "https://github.com/login/oauth/authorize"
    token_url                     = "https://github.com/login/oauth/access_token"
    attributes_url                = "https://api.github.com/user"
    jwks_uri                      = "https://token.actions.githubusercontent.com/.well-known/jwks"
  }

  attribute_mapping = {
    email    = "email"
    username = "sub"
  }
}
