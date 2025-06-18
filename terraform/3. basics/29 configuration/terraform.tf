terraform {

  required_version = "1.12.2" # exact version 1.12.1
  # required_version = ">= 1.12"  # greater than eqal to 1.12
  # required_version = "-> 1.12.0"  # any v1.12.x but not v.1.13.0 ot later
  # required_version = ">= 1.12.0 < 2.0.0" # greater than equal to 1.12.0 and less than 2.0.0

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.100.0"
    }
  }
}
