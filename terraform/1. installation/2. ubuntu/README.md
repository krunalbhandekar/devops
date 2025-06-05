# 🛠️ Terraform Installation on Ubuntu

This guide walks you through installing **Terraform** on Ubuntu using the official HashiCorp APT repository.

---

## ✅ Prerequisites

- Ubuntu 18.04 / 20.04 / 22.04+
- `sudo` privileges

---

## 🚀 Installation Steps

### 1. Update system packages

```bash
sudo apt update
```

### 2. Install required dependencies

```bash
sudo apt install -y gnupg software-properties-common curl
```

### 3. Add the HashiCorp GPG key

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

### 4. Add the HashiCorp APT repository

```bash
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
```

### 5. Update the package list again

```bash
sudo apt update
```

### 6. Install Terraform

```bash
sudo apt install -y terraform
```

### 7. Verify the installation

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
sudo apt remove terraform
```

---

### 👨‍💻 Author

Maintained by **[Krunal Bhandekar](https://www.linkedin.com/in/krunal-bhandekar/)**

---
