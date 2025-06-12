provider "aws" {
  region = var.region
}

# Create security group for allow ssh + http
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "allow ssh and http to alb"
  vpc_id      = var.vpc_id

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
  vpc_id      = var.vpc_id

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

# Launch template
resource "aws_launch_template" "lt" {
  for_each      = var.services
  name_prefix   = "lt-${each.key}"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    security_groups             = [aws_security_group.ec2_sg.id]
    associate_public_ip_address = true
  }

  user_data = base64encode(
    <<-EOF
    #!/bin/bash
    apt update && apt install nginx -y
    ${each.key != "home" ? "mkdir -p /var/www/html/${each.key}" : ""}
    echo "${each.value.html_content}" > ${each.key != "home" ? "/var/www/html/${each.key}/index.html" : "/var/www/html/index.html"}
    systemctl start nginx
    systemctl enable nginx
    EOF
  )

  tags = {
    Name = each.key
  }
}

# Create Load Balancer
resource "aws_lb" "alb" {
  name               = "aws-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.subnets
}

# Create Target Group
resource "aws_lb_target_group" "tg" {
  for_each = var.services
  name     = "tg-${each.key}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = each.value.path == "/" ? "/" : "/${each.key}"
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
    target_group_arn = aws_lb_target_group.tg["home"].arn
  }
}

# Create Dynamic Load Balancer Listener Rule
resource "aws_lb_listener_rule" "custom_path" {
  for_each     = { for k, v in var.services : k => v if k != "home" }
  listener_arn = aws_lb_listener.http.arn
  priority     = 10 + index(keys(var.services), each.key) # Ensure uniqueness

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[each.key].arn
  }

  condition {
    path_pattern {
      values = [each.value.path]
    }
  }
}

# Create Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  for_each = var.services
  name     = "asg-${each.key}"

  launch_template {
    id = aws_launch_template.lt[each.key].id
  }

  vpc_zone_identifier = var.subnets
  min_size            = 2
  max_size            = 4
  target_group_arns   = [aws_lb_target_group.tg[each.key].arn]
  health_check_type   = "ELB"

  tag {
    key                 = "Name"
    value               = each.key
    propagate_at_launch = true
  }
}

# Create Auto Scaling Policy
resource "aws_autoscaling_policy" "cpu" {
  for_each                  = var.services
  name                      = "policy-${each.key}"
  autoscaling_group_name    = aws_autoscaling_group.asg[each.key].name
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 60

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 20.0
  }
}

