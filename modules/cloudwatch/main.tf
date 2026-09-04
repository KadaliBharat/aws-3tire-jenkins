resource "aws_sns_topic" "alerts" {
  name = "${var.environment}-alerts-topic"
}

resource "aws_cloudwatch_metric_alarm" "web_cpu" {
  alarm_name          = "${var.environment}-web-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  
  dimensions = {
    AutoScalingGroupName = var.web_asg_name
  }
}

resource "aws_cloudwatch_metric_alarm" "app_cpu" {
  alarm_name          = "${var.environment}-app-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  
  dimensions = {
    AutoScalingGroupName = var.app_asg_name
  }
}
