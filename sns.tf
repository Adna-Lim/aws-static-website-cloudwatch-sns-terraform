# Notification for HTTP 4xx Errors
resource "aws_sns_topic" "cloudwatch_notifications_topic" {
  name = "CloudWatchNotificationsTopic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.cloudwatch_notifications_topic.arn
  protocol  = "email"
  endpoint  = "you email here" # specify email addresses to subcribe to this topic
}
