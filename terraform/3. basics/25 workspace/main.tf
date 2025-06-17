provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "tf_bucket" {
  bucket      = "my-bucket-${terraform.workspace}" # This uses 'terraform.workspace' to create unique resources per workspace.
  Environment = terraform.workspace
}

