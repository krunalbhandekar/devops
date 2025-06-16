provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "terraform_dynamic_sg" {
  name        = "tf-sg"
  description = "allow ssh and http"
  vpc_id      = "vpc-0100a9ff9eb4b0374"

  dynamic "ingress" { # This dynamic block will allow (run a loop) 22 ,80, and 443 port dynamically
    for_each = [22, 80, 443]
    iterator = port
    content {
      description = "dynamic-sg-port"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # All traffic
    cidr_blocks = ["0.0.0.0/0"] # Open to all
  }

  tags = {
    Name = "tf-sg"
  }
}
