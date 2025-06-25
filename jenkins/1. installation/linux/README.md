# 🛠️ Jenkins Installation on AWS EC2 (Amazon Linux 2) with Java 21

This guide helps you install and configure Jenkins on an AWS EC2 instance running Amazon Linux 2 with Java 21 (Temurin).

---

## 📦 Requirements

- AWS EC2 instance (Amazon Linux 2)
- Inbound rule open on **port 8080**
- SSH access to the instance
- `sudo` privileges

---

## ⚙️ Steps

### 1. Connect to your EC2 Instance

```bash
ssh -i <your-key.pem> ec2-user@<your-ec2-public-ip>
```

### 2. Update the System

```bash
sudo yum update -y
```

### 3. Install Java 21 (Temurin JDK)

```bash
# Import GPG key and add Adoptium repo
sudo rpm --import https://packages.adoptium.net/artifactory/api/gpg/key/public

cat <<EOF | sudo tee /etc/yum.repos.d/adoptium.repo
[Adoptium]
name=Adoptium
baseurl=https://packages.adoptium.net/artifactory/rpm/amazonlinux/2/\$(uname -m)
enabled=1
gpgcheck=1
gpgkey=https://packages.adoptium.net/artifactory/api/gpg/key/public
EOF

# Install Java 21
sudo yum install temurin-21-jdk -y
```

Verify Java:

```bash
java -version
```

### 4. Add Jenkins Repository

```bash
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
```

### 5. Install Jenkins

```bash
sudo yum install jenkins -y
```

### 6. Start and Enable Jenkins

```bash
sudo systemctl enable jenkins
sudo systemctl start jenkins
```

Check status:

```bash
sudo systemctl status jenkins
```

### 7. Allow Port 8080 (If Not Already Opened)

In your AWS Security Group, add an inbound rule:

- **Type:** Custom TCP
- **Port Range:** 8080
- **Source:** 0.0.0.0/0 (or your IP)

### 8. Access Jenkins

Open your browser and navigate to:

```cpp
http://<your-ec2-public-ip>:8080
```

### 9. Unlock Jenkins

Get the initial admin password:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Paste the password into the Jenkins UI and follow the setup wizard.

---

## ✅ Optional

**Install Git (Useful for Jenkins builds)**

```bash
sudo yum install git -y
```

---

## 🧹 Cleanup

To stop Jenkins:

```bash
sudo systemctl stop jenkins
```

To uninstall Jenkins:

```bash
sudo yum remove jenkins -y
```

---

### 👨‍💻 Author

Maintained by **[Krunal Bhandekar](https://www.linkedin.com/in/krunal-bhandekar/)**

---
