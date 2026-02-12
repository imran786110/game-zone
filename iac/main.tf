terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "game_zone" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "game_zone" {
  bucket = aws_s3_bucket.game_zone.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "game_zone" {
  bucket = aws_s3_bucket.game_zone.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_policy" "game_zone" {
  bucket = aws_s3_bucket.game_zone.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.game_zone.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.game_zone]
}

resource "aws_s3_object" "html_files" {
  for_each = fileset("${path.module}/../src", "*.html")

  bucket       = aws_s3_bucket.game_zone.id
  key          = each.value
  source       = "${path.module}/../src/${each.value}"
  content_type = "text/html"
  etag         = filemd5("${path.module}/../src/${each.value}")
}

resource "aws_cloudfront_distribution" "game_zone" {
  enabled             = true
  default_root_object = "index.html"
  price_class         = "PriceClass_100"

  origin {
    domain_name = aws_s3_bucket_website_configuration.game_zone.website_endpoint
    origin_id   = "S3-${var.bucket_name}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${var.bucket_name}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
