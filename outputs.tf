output "s3_bucket_name" {
  value = module.primary_s3_bucket.bucket_name
}

output "cloudfront_distribution_url" {
  value = aws_cloudfront_distribution.static_site_distribution.domain_name
}
