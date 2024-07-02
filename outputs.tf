output "s3_bucket_name" {
  value = aws_s3_bucket.static_site.bucket
}

output "cloudfront_distribution_url" {
  value = aws_cloudfront_distribution.static_site_distribution.domain_name
}
