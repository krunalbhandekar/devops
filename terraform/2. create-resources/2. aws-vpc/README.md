# 🌐 Create a Basic VPC on AWS Using Terraform

This guide helps you set up a **Virtual Private Cloud (VPC)** on AWS using Terraform with a public subnet, internet gateway, and route table.

---

## 📦 What This Creates

- A VPC (`10.0.0.0/16`)
- A public subnet (`10.0.1.0/24`)
- An internet gateway
- A route table with a route to the internet
- Route table association with the subnet

---

## 🧱 Project Structure

```bash
└── vpc.tf
```

### 📜 `vpc.tf` Example

```hcl
provider "aws" {
  region = "ap-south-1"
}

# 1. Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-vpc"
  }
}

# 2. Create Subnet
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "my-subnet"
  }
}

# 3. Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my-igw"
  }
}

# 4. Create Route Table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "my-route-table"
  }
}

# 5. Associate Route Table with Subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rt.id
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

## 🔐 Credentials Setup

- **Option 1: Running Terraform on AWS EC2**
  Attach an IAM Role with **admin** or required VPC permissions to the EC2 instance running Terraform.

- **Option 2: Running Locally or Other Machine**
  Use AWS CLI to configure credentials:

```bash
aws configure
```

---

## 🧹 Cleanup

To delete the resources created:

```bash
terraform destroy
```

---

## 🧠 Notes

- Adjust the CIDR blocks or availability zone based on your use case.
- This is a **minimal setup —** you can extend it with security groups, NAT gateways, private subnets, etc.

---

### 👨‍💻 Author

Maintained by **[Krunal Bhandekar](https://www.linkedin.com/in/krunal-bhandekar/)**

---
