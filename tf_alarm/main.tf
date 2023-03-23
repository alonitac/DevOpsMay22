terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.16"
    }
  }

  backend "s3" {
    ...
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = '...'
}


resource "aws_cloudwatch_metric_alarm" "alarm1" {
  alarm_name                = "alarm1-${var.env}-${var.region}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  alarm_actions       = [...]
  dimensions = {
    InstanceId = '...'
  }
}


resource "aws_cloudwatch_metric_alarm" "alarm2" {
  alarm_name                = "alarm1-${var.env}-${var.region}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  alarm_actions       = [...]
  dimensions = {
    InstanceId = '...'
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm3" {
  count = var.includeAlarm3inRegion ? 1 : 0
  alarm_name                = "alarm3-${var.env}-${var.region}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  alarm_actions       = [...]
  dimensions = {
    InstanceId = '...'
  }
}

