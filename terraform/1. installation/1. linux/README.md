# 📦 Terraform Installation on Amazon Linux

This guide provides step-by-step instructions to install **Terraform** on an Amazon Linux EC2 instance (Amazon Linux 2).

---

## ✅ Prerequisites

- Amazon EC2 instance running **Amazon Linux 2**
- User with `sudo` privileges

---

## 🚀 Installation Steps

### 1. Update packages and install `yum-utils`

```bash
sudo yum install -y yum-utils
```

### 2. Add the official HashiCorp Linux repository

```bash
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
```

### 3. Install Terraform

```bash
sudo yum -y install terraform
```

### 4. Verify the installation

```bash
terraform -v
```

Expected output:

```bash
Terraform v1.x.x
```

---

## 🔁 Uninstall Terraform (Optional)

If you ever need to remove Terraform:

```bash
sudo yum remove terraform
```

---

### 👨‍💻 Author

Maintained by **[Krunal Bhandekar](https://www.linkedin.com/in/krunal-bhandekar/)**

---
