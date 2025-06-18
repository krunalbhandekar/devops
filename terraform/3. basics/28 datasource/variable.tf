variable "img_owners" {
  type    = list(string)
  default = ["099720109477"]
}

variable "img_names" {
  type    = list(string)
  default = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
}

variable "img_root_device_type" {
  type    = list(string)
  default = ["ebs"]
}

variable "img_virtualization_type" {
  type    = list(string)
  default = ["hvm"]
}


