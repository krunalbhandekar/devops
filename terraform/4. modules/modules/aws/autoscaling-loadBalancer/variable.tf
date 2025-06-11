variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0100a9ff9eb4b0374"
}

variable "ami_id" {
  type    = string
  default = "ami-02521d90e7410d9f0"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "names" {
  type    = list(string)
  default = ["home", "mobile"]
}

variable "user_data_scripts" {
  type = list(string)
  default = [
    <<-EOF
    #!/bin/bash
    apt update && apt install nginx -y
    echo "<h1>Home</h1>" > /var/www/html/index.html
    systemctl start nginx
    ststemctl enable nginx
  EOF
    ,
    <<-EOF
    #!/bin/bash
    apt update && apt install nginx -y
    mkdir /var/www/html/mobile
    echo "<h1>Mobile</h1>" > /var/www/html/mobile/index.html
    systemctl start nginx
    ststemctl enable nginx
  EOF
  ]
}

variable "subnets" {
  type    = list(string)
  default = ["subnet-017210b3677394759", "subnet-0b575e3ed81f40f0f"]
}

variable "health_check_paths" {
  type    = list(string)
  default = ["/", "/mobile"]
}

