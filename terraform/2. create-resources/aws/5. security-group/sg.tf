provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "terraform_sg" {
  name        = "first-tf-sg"
  description = "allow ssh and http"
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
    Name = "tf-sg"
  }
}
