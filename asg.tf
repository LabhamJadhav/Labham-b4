provider "aws" {
    region = "ap-south-1"
  
}
resource "aws_launch_template" "lt-home" {
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  user_data = base64encode(<<-EOF
  #!/bin/bash
  apt update
  apt install nginx -y
  echo "<h1> Welcome to Home Page </h1>" > /var/www/html/index.html
  systemctl start nginx
  systemctl enable nginx
  EOF
  )
  tags = {
    Name = "${var.project}-LT-Home"
    env  = var.env
  }

}
resource "aws_security_group" "my-sg" {
  vpc_id = var.vpc_id
  ingress {
    protocol    = "TCP"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "TCP"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project}-SGG"
    env  = var.env
  }
}

resource "aws_launch_template" "lt-mobile" {
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  user_data = base64encode(<<-EOF
  #!/bin/bash
  apt update
  apt install nginx -y
  mkdir -p /var/www/html/mobile
  echo "<h1> Welcome to Mobile Page </h1>" > /var/www/html/mobile/index.html
  systemctl start nginx
  systemctl enable nginx
  EOF
  )
  tags = {
    Name = "${var.project}-LT-Mobile"
    env  = var.env
  }

}

resource "aws_launch_template" "lt-cloth" {
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  user_data = base64encode(<<-EOF
  #!/bin/bash
  apt update
  apt install nginx -y
  mkdir -p /var/www/html/cloth
  echo "<h1> Welcome to Cloth Page </h1>" > /var/www/html/cloth/index.html
  systemctl start nginx
  systemctl enable nginx
  EOF
  )
  tags = {
    Name = "${var.project}-LT-Cloth"
    env  = var.env
  }

}

resource "aws_autoscaling_group" "asg-home" {
  name               = "ASG-HOME"
  min_size           = 1
  max_size           = 3
  desired_capacity   = 2
  availability_zones = var.availability_zones
  launch_template {
    id = aws_launch_template.lt-home.id
  }
  target_group_arns = [aws_lb_target_group.tg-home.arn]
}

resource "aws_autoscaling_group" "asg-mobile" {
  name               = "ASG-Mobile"
  min_size           = 1
  max_size           = 3
  desired_capacity   = 2
  availability_zones = var.availability_zones
  launch_template {
    id = aws_launch_template.lt-mobile.id
  }
  target_group_arns = [aws_lb_target_group.tg-mobile.arn]
}

resource "aws_autoscaling_group" "asg-cloth" {
  name               = "ASG-Cloth"
  min_size           = 1
  max_size           = 3
  desired_capacity   = 2
  availability_zones = var.availability_zones
  launch_template {
    id = aws_launch_template.lt-cloth.id
  }
  target_group_arns = [aws_lb_target_group.tg-cloth.arn]
}

resource "aws_autoscaling_policy" "asgp-home" {
  name                   = "ASGP-home"
  autoscaling_group_name = aws_autoscaling_group.asg-home.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }
}

resource "aws_autoscaling_policy" "asgp-mobile" {
  name                   = "ASGP-mobile"
  autoscaling_group_name = aws_autoscaling_group.asg-mobile.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }
}

resource "aws_autoscaling_policy" "asgp-cloth" {
  name                   = "ASGP-cloth"
  autoscaling_group_name = aws_autoscaling_group.asg-cloth.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 60.0
  }
}
