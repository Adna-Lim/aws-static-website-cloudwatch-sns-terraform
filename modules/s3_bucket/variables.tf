variable "bucket_name" {
  description = "Name of S3 bucket"
  type        = string
}

variable "index_source" {
  description = "Source file for index.html"
  type        = string
}

variable "error_source" {
  description = "Source file for error.html"
  type        = string
}

variable "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution"
  type        = string
}
