# ==============================================================================
# Application Load Balancer (ALB)
# ==============================================================================

resource "aws_lb" "main_alb" {
  name               = "main-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_a.id]

    enable_deletion_protection = false #Set to true on Production

  tags = {
    Name = "main-alb"
  }
}

resource "aws_lb_target_group" "web_tg" {
  name        = "web-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
    target_type = "instance"

    health_check {
        enabled = true
        healthy_threshold = 3
        interval = 30
        path = "/"
        protocol = "HTTP"
        timeout = 5
        unhealthy_threshold = 2
    }
}

resource "aws_lb_target_group" "app_tg" {
    name        = "app-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
    target_type = "instance"
      health_check {
        enabled = true
        healthy_threshold = 3
        interval = 30
        path = "/"
        protocol = "HTTP"
        timeout = 5
        unhealthy_threshold = 2
    }

}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
      target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = "443"
  protocol          = "HTTPS"
#    ssl_policy = "ELBSecurityPolicy-2016-08" # Optional, use one of the predefined policy https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-listeners.html


  default_action {
    type = "forward"
      target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# Create Listener Rules to redirect different requests to app servers
resource "aws_lb_listener_rule" "app_listener_rule" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority = 100

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}