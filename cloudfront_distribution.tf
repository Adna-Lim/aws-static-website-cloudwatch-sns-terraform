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
    domain_name = aws_s3_bucket.static_site.bucket_regional_domain_name  
    origin_id   = "S3StaticSite"  
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
   
  }

  enabled             = true  
  default_root_object = "index.html"  

   custom_error_response {
    error_code       = 404
    response_code    = 404
    response_page_path = "/error.html" 
    error_caching_min_ttl = 10  
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"  
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]  
    cached_methods         = ["GET", "HEAD", "OPTIONS"]  
    target_origin_id       = "S3StaticSite" 

  forwarded_values {
      query_string = false  
      cookies {
        forward = "all"
      }
    }
  }

  # Optional: Define additional CloudFront settings here (e.g., SSL/TLS, caching behavior)
  restrictions {
    geo_restriction {
      restriction_type = "none"  
    }
  }
}
