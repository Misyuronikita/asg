resource "aws_security_group" "alb_sg" {
  name        = "alb_sg_misyuro"
  description = "ASG security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb_sg_misyuro"
  }
}

resource "aws_security_group" "asg_sg" {
  name        = "asg_sg_misyuro"
  description = "ASG security group"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description     = "HTTP for ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "asg_sg_misyuro"
  }
}
