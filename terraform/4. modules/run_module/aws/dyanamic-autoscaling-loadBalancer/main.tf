module "dynamic-asg-alb" {
  source = "../../../modules/aws/dynamic-autoscaling-loadBalancer" # write path of your module

  # Change the values according to your need
  region        = "ap-south-1"
  vpc_id        = "vpc-0100a9ff9eb4b0374"
  ami_id        = "ami-02521d90e7410d9f0"
  instance_type = "t2.micro"
  services = {
    home = {
      path         = "/"
      html_content = "<h1>Home</h1>"
    },
    mobile = {
      path         = "/mobile*"
      html_content = "<h1>Mobile</h1>"
    },
    laptop = {
      path         = "/laptop*"
      html_content = "<h1>Laptop</h1>"
    },
  }
  subnets = ["subnet-017210b3677394759", "subnet-0b575e3ed81f40f0f"]
}
