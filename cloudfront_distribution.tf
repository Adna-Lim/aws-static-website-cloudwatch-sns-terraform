# Origin Access Identity (OAC) for CloudFront
resource "aws_cloudfront_origin_access_control" "oac" {
	name                              = "some-name"
	description                       = ""
	origin_access_control_origin_type = "s3"
	signing_behavior                  = "always"
	signing_protocol                  = "sigv4"
}

# CloudFront distribution for the S3 static website
resource "aws_cloudfront_distribution" "static_site_distribution" {
  origin {
    domain_name = module.primary_s3_bucket.bucket_regional_domain_name
    origin_id   = "primary-static-site"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  origin {
    domain_name = module.secondary_s3_bucket.bucket_regional_domain_name
    origin_id   = "secondary-static-site"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  origin_group {
    origin_id = "origin-group-1"

    failover_criteria {
      status_codes = [500, 502, 503, 504]
    }

    member {
      origin_id = "primary-static-site"
    }

    member {
      origin_id = "secondary-static-site"
    }
  }

  enabled             = true
  default_root_object = "index.html"

  custom_error_response {
    error_code            = 404
    response_code         = 404
    response_page_path    = "/error.html"
    error_caching_min_ttl = 10
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = "origin-group-1"

    forwarded_values {
      query_string = false
      cookies {
        forward = "all"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
