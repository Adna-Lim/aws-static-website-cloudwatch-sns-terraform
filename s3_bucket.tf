module "primary_s3_bucket" {
  source                     = "./modules/s3_bucket"
  bucket_name                = var.bucket_name
  index_source               = "${path.module}/website/index.html"
  error_source               = "${path.module}/website/error.html"
  cloudfront_distribution_arn = aws_cloudfront_distribution.static_site_distribution.arn
}

# secondary bucket in event of failover
module "secondary_s3_bucket" {
  source                     = "./modules/s3_bucket"
  bucket_name                = "${var.bucket_name}-secondary"
  index_source               = "${path.module}/website/index.html"
  error_source               = "${path.module}/website/error.html"
  cloudfront_distribution_arn = aws_cloudfront_distribution.static_site_distribution.arn
}
