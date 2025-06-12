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

variable "services" {
  type = map(object({
    path         = string
    html_content = string
  }))

  default = {
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
}

variable "subnets" {
  type    = list(string)
  default = ["subnet-017210b3677394759", "subnet-0b575e3ed81f40f0f"]
}
