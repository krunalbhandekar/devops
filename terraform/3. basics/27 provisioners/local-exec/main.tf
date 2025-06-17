provider "aws" {
  region = "ap-south-1"
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "terraform-key"
  public_key = tls_private_key.example.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.example.private_key_pem
  filename        = "${path.module}/terraform-key.pem"
  file_permission = "0400"
}

resource "aws_instance" "file_provisioner" {
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.generated_key.key_name

  tags = {
    Name = "check-file-provisioner"
  }

  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.example.private_key_pem
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > /tmp/mypublicip.txt"
  }

  provisioner "local-exec" {
    working_dir = "/tmp/"
    command     = "echo ${self.public_ip} > mypublicipintmp.txt"
  }

  provisioner "local-exec" {
    command = "env>env.txt"
    environment = {
      envname = "envvalue"
    }
  }

  provisioner "local-exec" {
    command = "echo 'at create/apply'"
  }

  provisioner "local-exec" {
    when    = destroy # this provisioner run while destroying
    command = "echo 'at delete'"
  }
}

