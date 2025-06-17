provider "aws" {
  region = "us-east-1"
}

variable "bucket_name" {
  type    = string
  default = "krunal-terraform-state-bucket" # Replace with a unique bucket name
}

# Create the S3 bucket
resource "aws_s3_bucket" "tf_backend" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = {
    Name        = "Terraform State Bucket"
    Environment = terraform.workspace
  }
}

# Enable Versioning
resource "aws_s3_bucket_versioning" "tf_backend_versioning" {
  bucket = aws_s3_bucket.tf_backend.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Uncomment this block only AFTER the bucket above has been created
# ---------- Step 2: Re-initialize Terraform using this backend ----------

# terraform {
#   backend "s3" {
#     bucket = var.bucket_name
#     key    = "env/dev/terraform.tfstate"
#     region = "us-east-1"
#   }
# }
