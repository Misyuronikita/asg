resource "aws_lb" "alb" {
  name               = "alb-misyuro"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for item in aws_subnet.public_subnet : item.id]
}

resource "aws_lb_target_group" "target_group" {
  name     = "tg-misyuro"
  protocol = "HTTP"
  port     = 80
  vpc_id   = aws_vpc.vpc.id

  health_check {
    path    = "/"
    matcher = 200
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}
