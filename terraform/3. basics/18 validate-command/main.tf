provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "ec2" {
  instance_type = "t2.micro"
}
