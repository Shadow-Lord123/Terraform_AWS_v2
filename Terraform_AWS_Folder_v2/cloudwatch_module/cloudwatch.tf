
resource "aws_cloudwatch_metric_alarm" "read_capacity_alarm" {
  alarm_name                = "terraform-test-read-capacity"
  comparison_operator       = "LessThanThreshold"  # Adjust comparison operator
  evaluation_periods        = 5  # 5 evaluation periods (reduce sensitivity)
  metric_name               = "ConsumedReadCapacityUnits"
  namespace                 = "AWS/DynamoDB"  # Ensure you're using the correct namespace for DynamoDB
  period                    = 60  # 1 minute (adjust if needed)
  statistic                 = "Average"  # Choose appropriate statistic (Average, Sum, etc.)
  threshold                 = 50  # Set a threshold value that's appropriate for your application
  alarm_description         = "This metric monitors DynamoDB read capacity usage"
  insufficient_data_actions = []  # No action on insufficient data
}

resource "aws_cloudwatch_metric_alarm" "write_capacity_alarm" {
  alarm_name                = "terraform-test-write-capacity"
  comparison_operator       = "LessThanThreshold"  # Adjust comparison operator
  evaluation_periods        = 5  # Adjust evaluation periods for less sensitivity
  metric_name               = "ConsumedWriteCapacityUnits"
  namespace                 = "AWS/DynamoDB"  # Correct namespace for DynamoDB
  period                    = 60  # 1 minute (adjust if needed)
  statistic                 = "Average"
  threshold                 = 50  # Set a realistic threshold value based on your usage
  alarm_description         = "This metric monitors DynamoDB write capacity usage"
  insufficient_data_actions = []  # No action on insufficient data
}
