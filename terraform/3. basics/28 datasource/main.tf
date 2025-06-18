provider "aws" {
  region = "ap-south-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = var.img_owners

  filter {
    name   = "name"
    values = var.img_names
  }

  filter {
    name   = "root-device-type"
    values = var.img_root_device_type
  }

  filter {
    name   = "virtualization-type"
    values = var.img_virtualization_type
  }
}

output "ami_id" {
  value = data.aws_ami.ubuntu.id
}

resource "aws_instance" "name" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "datasource-instance"
  }
}

