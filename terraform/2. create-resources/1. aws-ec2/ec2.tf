provider "aws" {
  region = "ap-south-1"  # Change to your preferred region
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-0f535a71b34f2d44a" # Amazon Linux 2 AMI for ap-south-1

  instance_type = "t2.micro"  # Change to required instance type

  key_name = "mumbai-key-pair" # Change to your key-pair name of preferred region

  tags = {
    Name = "My-First-EC2-Using-Terraform"
  }
}