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
  count         = 2
  name_prefix   = "lt-${element(var.names, count.index)}"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    security_groups             = [aws_security_group.ec2_sg.id]
    associate_public_ip_address = true
  }

  user_data = base64encode(element(var.user_data_scripts, count.index))

  tags = {
    Name = element(var.names, count.index)
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
  count    = 2
  name     = "tg-${element(var.names, count.index)}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = element(var.health_check_paths, count.index)
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
    target_group_arn = aws_lb_target_group.tg[0].arn
  }
}

# Create Load Balancer Listener Rule
resource "aws_lb_listener_rule" "mobile_path" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[1].arn
  }
  condition {
    path_pattern {
      values = ["/mobile*"]
    }
  }
}

# Create Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  count = 2
  name  = "asg-${element(var.names, count.index)}"

  launch_template {
    id = aws_launch_template.lt[count.index].id
  }

  vpc_zone_identifier = var.subnets
  min_size            = 2
  max_size            = 4
  target_group_arns   = [aws_lb_target_group.tg[count.index].arn]
  health_check_type   = "ELB"

  tag {
    key                 = "Name"
    value               = element(var.names, count.index)
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "cpu" {
  count                     = 2
  name                      = "policy-${element(var.names, count.index)}"
  autoscaling_group_name    = aws_autoscaling_group.asg[count.index].name
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 60

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 20.0
  }
}
