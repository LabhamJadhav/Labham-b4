resource "aws_lb_target_group" "tg_home" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/"
  }

  tags = {
    Name = "${var.project}-TG-Home"
  }
}

resource "aws_lb_target_group" "tg_mobile" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/mobile/index.html"
  }

  tags = {
    Name = "${var.project}-TG-Mobile"
  }
}

resource "aws_lb_target_group" "tg_cloth" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/cloth/index.html"
  }

  tags = {
    Name = "${var.project}-TG-Cloth"
  }
}

resource "aws_lb" "my_alb" {
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = var.subnets

  tags = {
    Name = "${var.project}-ALB"
    env  = var.env
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_home.arn
  }
}

resource "aws_lb_listener_rule" "rule_mobile" {
  listener_arn = aws_lb_listener.alb_listener.arn
  priority     = 101

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_mobile.arn
  }

  condition {
    path_pattern {
      values = ["/mobile/*"]
    }
  }
}

resource "aws_lb_listener_rule" "rule_cloth" {
  listener_arn = aws_lb_listener.alb_listener.arn
  priority     = 102

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_cloth.arn
  }

  condition {
    path_pattern {
      values = ["/cloth/*"]
    }
  }
}
