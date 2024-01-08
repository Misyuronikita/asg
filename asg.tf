resource "aws_launch_template" "launch_template" {
  name          = "launch_template_misyuro"
  image_id      = var.ami
  instance_type = var.instance_type

  network_interfaces {
    device_index    = 0
    security_groups = [aws_security_group.asg_sg.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "launch_template_misyuro"
    }
  }
  user_data = filebase64("user_data.sh")
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = [for item in aws_subnet.private_subnet[*] : item.id]
  target_group_arns   = [aws_lb_target_group.target_group.arn]

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = aws_launch_template.launch_template.latest_version
  }
}

