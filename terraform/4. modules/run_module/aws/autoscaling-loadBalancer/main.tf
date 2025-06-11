module "asg-alb" {
  source = "../../../modules/aws/autoscaling-loadBalancer" # write path of your module

  # Change the values according to your need
  region        = "ap-south-1"
  vpc_id        = "vpc-0100a9ff9eb4b0374"
  ami_id        = "ami-02521d90e7410d9f0"
  instance_type = "t2.micro"
  names         = ["home", "mobile"]
  user_data_scripts = [
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
  subnets            = ["subnet-017210b3677394759", "subnet-0b575e3ed81f40f0f"]
  health_check_paths = ["/", "/mobile"]
}
