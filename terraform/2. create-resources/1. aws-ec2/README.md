# 🚀 Create a Basic AWS EC2 Instance Using Terraform

This guide helps you create a simple **EC2 instance** on **AWS** using **Terraform**.

---

## ⚙️ Prerequisites

- Terraform installed (`terraform -v`)
- AWS account
- Internet access from the system running Terraform

---

## 🔐 AWS Credentials Setup

### Option 1: Running Terraform on an EC2 Instance (Recommended)

> ✅ **Attach an IAM role** with **admin** or appropriate EC2/VPC permissions to the EC2 instance running Terraform.

This avoids storing AWS credentials on the instance.

---

### Option 2: Running Terraform Locally or on Other Servers

> 📌 **Configure the AWS CLI with your credentials:**

```bash
aws configure
```

This stores your credentials in `~/.aws/credentials`.

---

## 📁 Project Structure

```bash
└── ec2.tf
```

### 📜 `ec2.tf` Example

```bash
provider "aws" {
  region = "ap-south-1"  # Change to your preferred region
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-0f535a71b34f2d44a" # Amazon Linux 2 AMI for ap-south-1

  instance_type = "t2.micro"  # Change to required instance type

  key_name = "mumbai-key-pair" # Change to your key-pair name of preferred region

  tags = {
    Name = "My-First-EC2-Using-Terraform"
  }
}
```

🔄 Replace the required values

---

## 🧪 Terraform Commands

**1. Initialize Terraform**

```bash
terraform init
```

**2. Preview the execution plan**

```bash
terraform plan
```

**3. Apply the configuration**

```bash
terraform apply
```

Type `yes` to confirm.

**4. (Optional) Destroy the resources**

```bash
terraform destroy
```

---

## ✅ Result

- You will see a new EC2 instance in your AWS console, tagged as **"My-First-EC2-Using-Terraform"**.

---

## 📎 Notes

- Make sure your IAM role or user has the required permissions to create EC2 instances.
- Security groups, key pairs, and networking can be added later as needed.

---

### 👨‍💻 Author

Maintained by **[Krunal Bhandekar](https://www.linkedin.com/in/krunal-bhandekar/)**

---
