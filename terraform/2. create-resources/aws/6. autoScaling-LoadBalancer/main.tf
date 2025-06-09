provider "aws" {
  region = "ap-south-1"
}

# Create security group for allow ssh + http

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "allow ssh and http to alb"
  vpc_id      = "vpc-0100a9ff9eb4b0374"

  # ingress = inbound rule

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to all
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to all
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # All traffic
    cidr_blocks = ["0.0.0.0/0"] # Open to all
  }

  tags = {
    Name = "alb-sg"
  }
}

# Create security group for allow traffic from above alb sg only

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "allow traffic from alb"
  vpc_id      = "vpc-0100a9ff9eb4b0374"

  # ingress = inbound rule

  ingress {
    description     = "HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # All traffic
    cidr_blocks = ["0.0.0.0/0"] # Open to all
  }

  tags = {
    Name = "ec2-sg"
  }
}

# Launch template for home menu

resource "aws_launch_template" "lt_home" {
  name_prefix   = "lt-home"
  image_id      = "ami-02521d90e7410d9f0"
  instance_type = "t2.micro"

  network_interfaces {
    security_groups             = [aws_security_group.ec2_sg.id]
    associate_public_ip_address = true
  }

  # User data script using heredoc
  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt update && apt install nginx -y
    echo "<h1>Home</h1>" > /var/www/html/index.html
    systemctl start nginx
    ststemctl enable nginx
  EOF
  )

  tags = {
    Name = "Home"
  }
}

# Launch template for mobile menu

resource "aws_launch_template" "lt_mobile" {
  name_prefix   = "lt-mobile"
  image_id      = "ami-02521d90e7410d9f0"
  instance_type = "t2.micro"

  network_interfaces {
    security_groups             = [aws_security_group.ec2_sg.id]
    associate_public_ip_address = true
  }

  # User data script using heredoc
  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt update && apt install nginx -y
    echo "<h1>Mobile</h1>" > /var/www/html/mobile/index.html
    systemctl start nginx
    ststemctl enable nginx
  EOF
  )

  tags = {
    Name = "Mobile"
  }
}

# Create Load Balancer

resource "aws_lb" "alb" {
  name               = "aws-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = ["subnet-017210b3677394759", "subnet-0b575e3ed81f40f0f"]
}

# Create Target Group for Home

resource "aws_lb_target_group" "home" {
  name     = "tg-home"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0100a9ff9eb4b0374"
  health_check {
    path                = "/"
    interval            = 60
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# Create Target Group for Mobile

resource "aws_lb_target_group" "mobile" {
  name     = "tg-mobile"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0100a9ff9eb4b0374"
  health_check {
    path                = "/mobile"
    interval            = 60
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# Create Load Balancer Listener

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.home.arn
  }
}

# Create Load Balancer Listener Rule

resource "aws_lb_listener_rule" "mobile_path" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mobile.arn
  }
  condition {
    path_pattern {
      values = ["/mobile*"]
    }
  }
}

# Create Auto Scaling Group for home

resource "aws_autoscaling_group" "home_asg" {
  name = "asg-home"
  launch_template {
    id = aws_launch_template.lt_home.id
  }
  vpc_zone_identifier = ["subnet-017210b3677394759", "subnet-0b575e3ed81f40f0f"]
  min_size            = 2
  max_size            = 4
  target_group_arns   = [aws_lb_target_group.home.arn]
  health_check_type   = "ELB"

  tag {
    key                 = "Name"
    value               = "home"
    propagate_at_launch = true
  }
}

# Create Auto Scaling Policy for home

resource "aws_autoscaling_policy" "home_cpu" {
  name                      = "home-cpu-policy"
  autoscaling_group_name    = aws_autoscaling_group.home_asg.name
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 60

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 20.0
  }
}

# Create Auto Scaling Group for mobile

resource "aws_autoscaling_group" "mobile_asg" {
  name = "asg-mobile"
  launch_template {
    id = aws_launch_template.lt_mobile.id
  }
  vpc_zone_identifier = ["subnet-017210b3677394759", "subnet-0b575e3ed81f40f0f"]
  min_size            = 2
  max_size            = 4
  target_group_arns   = [aws_lb_target_group.mobile.arn]
  health_check_type   = "ELB"

  tag {
    key                 = "Name"
    value               = "mobile"
    propagate_at_launch = true
  }
}

# Create Auto Scaling Policy for mobile

resource "aws_autoscaling_policy" "mobile_cpu" {
  name                      = "mobile-cpu-policy"
  autoscaling_group_name    = aws_autoscaling_group.mobile_asg.name
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 60

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 20.0
  }
}



