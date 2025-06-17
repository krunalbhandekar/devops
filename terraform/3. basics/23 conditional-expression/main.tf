provider "aws" {
  region = "ap-south-1"
}

variable "enable_versioning" {
  description = "whether to enable versioning on the s3 bucket"
  type        = bool
  default     = false
}

resource "aws_s3_bucket" "tf_bucket" {
  bucket = "my-bucket"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tf_bucket.id
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}
