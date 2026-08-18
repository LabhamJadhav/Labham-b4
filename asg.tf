provider "aws"  {
  region = "ap-south-1"
}
resource "aws_launch_template" "lt_home" {
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt update
    apt install nginx -y

    echo "<h1>Welcome to Home Page</h1>" > /var/www/html/index.html

    systemctl start nginx
    systemctl enable nginx
  EOF
  )

  tags = {
    Name = "${var.project}-LT-Home"
    env  = var.env
  }
}
resource "aws_security_group" "my_sg" {
  vpc_id = var.vpc_id

  # HTTP
  ingress {
    protocol    = "TCP"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH
  ingress {
    protocol    = "TCP"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-SG"
    env  = var.env
  }
}
resource "aws_launch_template" "lt_mobile" {
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt update
    apt install nginx -y

    mkdir -p /var/www/html/mobile

    echo "<h1>Welcome to Mobile Page</h1>" > /var/www/html/mobile/index.html

    systemctl start nginx
    systemctl enable nginx
  EOF
  )

  tags = {
    Name = "${var.project}-LT-Mobile"
    env  = var.env
  }
}
resource "aws_launch_template" "lt_cloth" {
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt update
    apt install nginx -y

    mkdir -p /var/www/html/cloth

    echo "<h1>Welcome to Cloth Page</h1>" > /var/www/html/cloth/index.html

    systemctl start nginx
    systemctl enable nginx
  EOF
  )

  tags = {
    Name = "${var.project}-LT-Cloth"
    env  = var.env
  }
}


resource "aws_autoscaling_group" "asg_home" {
  name             = "ASG-HOME"
  min_size         = 1
  max_size         = 2
  desired_capacity = 1

  availability_zones = var.availability_zones

  launch_template {
    id      = aws_launch_template.lt_home.id
    version = "$Latest"
  }

  target_group_arns = [
    aws_lb_target_group.tg_home.arn
  ]
}

resource "aws_autoscaling_group" "asg_mobile" {
  name             = "ASG-MOBILE"
  min_size         = 1
  max_size         = 2
  desired_capacity = 1

  availability_zones = var.availability_zones

  launch_template {
    id      = aws_launch_template.lt_mobile.id
    version = "$Latest"
  }

  target_group_arns = [
    aws_lb_target_group.tg_mobile.arn
  ]
}

resource "aws_autoscaling_group" "asg_cloth" {
  name             = "ASG-CLOTH"
  min_size         = 1
  max_size         = 3
  desired_capacity = 2

  availability_zones = var.availability_zones

  launch_template {
    id      = aws_launch_template.lt_cloth.id
    version = "$Latest"
  }

  target_group_arns = [
    aws_lb_target_group.tg_cloth.arn
  ]
}

resource "aws_autoscaling_policy" "asgp_home" {
  name                   = "ASGP-home"
  autoscaling_group_name = aws_autoscaling_group.asg_home.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 60.0
  }
}

resource "aws_autoscaling_policy" "asgp_mobile" {
  name                   = "ASGP-mobile"
  autoscaling_group_name = aws_autoscaling_group.asg_mobile.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }
}

resource "aws_autoscaling_policy" "asgp_cloth" {
  name                   = "ASGP-cloth"
  autoscaling_group_name = aws_autoscaling_group.asg_cloth.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 60.0
  }
}


resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id

  # HTTP
  ingress {
    protocol    = "TCP"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-ALB-SG"
    env  = var.env
  }
}
