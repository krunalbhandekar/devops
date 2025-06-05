provider "aws" {
  region = "ap-south-1"
}

# Create IAM user
resource "aws_iam_user" "example_user" {
  name = "krunal-user"
  tags = {
    Purpose = "Terraform-Created-User"
  }
}

# Attach AdministratorAccess policy (optional)
resource "aws_iam_user_policy_attachment" "admin_attach" {
  user       = aws_iam_user.example_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Create Access Key
resource "aws_iam_access_key" "example_key" {
  user = aws_iam_user.example_user.name
}

# Output Access Key ID
output "access_key_id" {
  value = aws_iam_access_key.example_key.id
}

# Output Secret Access Key (sensitive)
output "secret_access_key" {
  value     = aws_iam_access_key.example_key.secret
  sensitive = true
}