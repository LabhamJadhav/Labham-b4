resource "aws_lb_target_group" "tg-home" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  tags = {
    Name = "${var.project}-TG-Home"
  }
}

resource "aws_lb_target_group" "tg-mobile" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  tags = {
    Name = "${var.project}-TG-Mobile"
  }

  health_check {
    path = "/mobile"
  }
}

resource "aws_lb_target_group" "tg-cloth" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  tags = {
    Name = "${var.project}-TG-Cloth"
  }

  health_check {
    path = "/cloth"
  }
  }


resource "aws_lb" "my-alb" {
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ALB-sg.id]
  subnets            = var.subnets


  tags = {
    Name = "${var.project}-ALB"
    env  = var.env
  }
}

resource "aws_lb_listener" "alb-listenr" {
  load_balancer_arn = aws_lb.my-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-home.arn
  }
}

resource "aws_lb_listener_rule" "rule-mobile" {
  listener_arn = aws_lb_listener.alb-listenr.arn
  priority     = 101

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-mobile.arn
  }

  condition {
    path_pattern {
      values = ["/mobile/*"]
    }
  }

}

resource "aws_lb_listener_rule" "rule-cloth" {
  listener_arn = aws_lb_listener.alb-listenr.arn
  priority     = 102

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-cloth.arn
  }

  condition {
    path_pattern {
      values = ["/cloth/*"]
    }
  }

}

resource "aws_security_group" "ALB-sg" {
  vpc_id = var.vpc_id
  ingress {
    protocol    = "TCP"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}