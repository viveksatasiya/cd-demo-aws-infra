resource "aws_lb" "ecs_alb" {
  name                       = "cd-demo-ecs-alb-${terraform.workspace}"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb_sg.id]
  subnets                    = aws_subnet.ecs_subnet.*.id
  enable_deletion_protection = false

  enable_cross_zone_load_balancing = true

  tags = {
    Name = "ecs-alb-${terraform.workspace}"
  }
}

resource "aws_lb_listener" "ecs_alb_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Error. Target group not configured."
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "ecs_alb_listener_rule" {
  listener_arn = aws_lb_listener.ecs_alb_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }

  lifecycle {
    ignore_changes = [action]
  }
}


resource "aws_lb_target_group" "ecs_tg" {
  name                 = "cd-demo-ecs-tg-${terraform.workspace}"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = aws_vpc.ecs_vpc.id
  deregistration_delay = 30

  health_check {
    enabled             = true
    interval            = 30
    path                = "/health"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "ecs_tg_green" {
  name                 = "cd-demo-ecs-tg-green-${terraform.workspace}"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = aws_vpc.ecs_vpc.id
  deregistration_delay = 30

  health_check {
    enabled             = true
    interval            = 30
    path                = "/health"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}


resource "aws_security_group" "alb_sg" {
  name        = "cd-demo-${terraform.workspace}-alb-sg"
  description = "Security group for the ALB"
  vpc_id      = aws_vpc.ecs_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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
    Name        = "cd-demo-${terraform.workspace}-alb-sg"
    Environment = terraform.workspace
  }
}

