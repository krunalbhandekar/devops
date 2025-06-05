# 👤 Create AWS IAM User with Access Keys Using Terraform

This guide will help you create an AWS IAM user and generate programmatic access keys **(Access Key ID and Secret Access Key)** using Terraform.

---

## ⚙️ Prerequisites

- Terraform installed (`terraform -v`)
- AWS credentials configured:
  - If you're running on **AWS EC2**, attach an IAM role with IAM permissions
  - Otherwise, configure with `aws configure`

---

## 🧱 Project Structure

```bash
└── iamuser.tf
```

### 📜 `iamuser.tf` Example

```hcl
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
```

---

## ⚙️ How to Use

**1. Initialize Terraform**

```bash
terraform init
```

**2. Review the Plan**

```bash
terraform plan
```

**3. Apply the Configuration**

```bash
terraform apply
```

Type `yes` to confirm and create resources.

---

## 🔐 Viewing the Access Keys

**To View `access_key_id` :**

```bash
terraform output access_key_id
```

**To View `secret_access_key` (sensitive):**

```bash
terraform output -json secret_access_key
```

---

## 🧹 To Destroy the User

```bash
terraform destroy
```

---

## 📎 Notes

- Always rotate and securely store your access keys.
- For production use, follow the principle of least privilege — avoid using `AdministratorAccess`.

---

### 👨‍💻 Author

Maintained by **[Krunal Bhandekar](https://www.linkedin.com/in/krunal-bhandekar/)**

---
