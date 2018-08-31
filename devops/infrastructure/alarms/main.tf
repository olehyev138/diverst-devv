variable "instance_ids" {
  type = "list"
}

variable "alarm_actions" {
  type = "list"
}

variable "region" {
  default = "us-east-1"
}

resource "aws_cloudwatch_metric_alarm" "system_failed" {
  count = "${length(var.instance_ids)}"

  alarm_name = "${var.instance_ids[count.index]}-SystemCheckFailed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  period = "60"
  evaluation_periods = "2"
  metric_name = "StatusCheckFailed_System"
  namespace = "AWS/EC2"
  statistic = "Minimum"
  threshold = "1"
  alarm_actions = ["${concat(list("arn:aws:automate:${var.region}:ec2:recover"), var.alarm_actions)}"]

  dimensions {
    InstanceId = "${element(var.instance_ids, count.index)}"
  }
}

resource "aws_cloudwatch_metric_alarm" "instance_failed" {
  count = "${length(var.instance_ids)}"

  alarm_name = "${var.instance_ids[count.index]}-InstanceCheckFailed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  period = "60"
  evaluation_periods = "2"
  metric_name = "StatusCheckFailed_Instance"
  namespace = "AWS/EC2"
  statistic = "Minimum"
  threshold = "1"
  alarm_actions = ["${var.alarm_actions}"]

  dimensions {
    InstanceId = "${element(var.instance_ids, count.index)}"
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  count = "${length(var.instance_ids)}"

  alarm_name = "${var.instance_ids[count.index]}-HighCPUUsage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  period = "300"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  statistic = "Average"
  threshold = "80"
  alarm_actions = ["${var.alarm_actions}"]

  dimensions {
    InstanceId = "${element(var.instance_ids, count.index)}"
  }
}
