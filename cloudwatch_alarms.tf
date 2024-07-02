resource "aws_iam_policy" "cloudwatch_policy" {
  name        = "CloudWatchAccessPolicy"
  description = "Allows CloudWatch to access metrics and alarms"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:GetDashboard",
          "cloudwatch:ListMetrics"
        ],
        Resource = aws_cloudfront_distribution.static_site_distribution.arn
      }
    ]
  })
}

resource "aws_iam_role" "cloudwatch_role" {
  name               = "CloudWatchRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_policy_attachment" {
  role       = aws_iam_role.cloudwatch_role.name
  policy_arn = aws_iam_policy.cloudwatch_policy.arn
}

# Include additional CloudWatch Metric Alarm as per your requirements eg. 5xx error rate, Total error rate etc
resource "aws_cloudwatch_metric_alarm" "http_4xx_errors_alarm" {
  alarm_name                = "HTTP 4xx Errors Alarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 1
  metric_name               = "4xxErrorRate"
  namespace                 = "AWS/CloudFront"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 1
  alarm_description         = "Alarm if HTTP 4xx Errors exceed threshold"

  dimensions = {
    DistributionId = aws_cloudfront_distribution.static_site_distribution.id
    Region         = "Global"
  }

  alarm_actions = [
    aws_sns_topic.cloudwatch_notifications_topic.arn
  ]  # Add SNS topic or other actions if needed
}
