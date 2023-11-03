
resource "aws_launch_template" "web" {
  name = "web_launch_template"
  description = "Launch template for Hello world Nodejs"

  image_id = var.ami_id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = var.instance_type

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "web"
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.allow_http_web.id]
  }

  user_data = filebase64("${path.module}/user_data.sh")
}

resource "aws_autoscaling_group" "web" {
  name_prefix = "autoscaling-group-for-${aws_launch_template.web.name}--"
  availability_zones = var.availability_zones
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size

  health_check_grace_period = 300
  health_check_type         = "ELB"

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.web.arn]
}

resource "aws_autoscaling_policy" "web" {
  name                   = "upscale-web-based-on-network-bytes-out"
  scaling_adjustment     = var.scaling_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web.name
}

resource "aws_cloudwatch_metric_alarm" "request_count" {
  alarm_description = "Alarm when web NetworkOut exceeds 500 bytes"
  alarm_name          = "NetworkOutWebAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 1
  metric_name         = "NetworkOut"
  namespace           = "AWS/EC2"
  period              = 120

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  statistic = "Average"
  threshold = 50000

  alarm_actions     = [aws_autoscaling_policy.web.arn]
}

