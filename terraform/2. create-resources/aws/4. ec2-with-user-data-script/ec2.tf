provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "ec2-user-script" {
  ami           = "ami-02521d90e7410d9f0"
  instance_type = "t2.micro"
  key_name      = "mumbai-key-pair"

  # User data script using heredoc
  user_data = <<-EOF
    #!/bin/bash
    apt update && apt install nginx -y
    echo "<h1>Hello From Terraform EC2 instance!</h1>" > /var/www/html/index.html
    systemctl start nginx
    ststemctl enable nginx
  EOF

  tags = {
    Name = "TerraformEC2Instance"
  }
}
