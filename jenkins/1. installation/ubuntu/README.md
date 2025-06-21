# 🛠️ Jenkins Installation on AWS EC2 (Ubuntu) with Java 21

This guide helps you install and configure Jenkins on an AWS EC2 instance running Ubuntu with Java 21 (Temurin).

---

## 📦 Requirements

- AWS EC2 instance (Ubuntu)
- Inbound rule open on **port 8080**
- SSH access to the instance
- `sudo` privileges

---

## ⚙️ Steps

### 1. Connect to your EC2 Instance

```bash
ssh -i <your-key.pem> ubuntu@<your-ec2-public-ip>
```

### 2. Update the System

```bash
sudo apt update && sudo apt upgrade -y
```

### 3. Install Java 21 (Temurin JDK)

```bash
# Add the Adoptium GPG key
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo gpg --dearmor -o /usr/share/keyrings/adoptium-archive-keyring.gpg

# Add the repository
echo "deb [signed-by=/usr/share/keyrings/adoptium-archive-keyring.gpg] https://packages.adoptium.net/artifactory/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/adoptium.list

# Update package list
sudo apt update

# Install Java 21
sudo apt install temurin-21-jdk -y
```

Verify Java:

```bash
java -version
```

### 4. Add Jenkins Repository

```bash
# Add the Jenkins key
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Add Jenkins repository
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package list
sudo apt update
```

### 5. Install Jenkins

```bash
sudo apt install jenkins -y
```

### 6. Start and Enable Jenkins

```bash
sudo systemctl start jenkins
sudo systemctl enable jenkins
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
sudo apt install git -y
```

---

## 🧹 Cleanup

To stop Jenkins:

```bash
sudo systemctl stop jenkins
```

To uninstall Jenkins:

```bash
sudo apt remove --purge jenkins -y
```

---

### 👨‍💻 Author

Maintained by **[Krunal Bhandekar](https://www.linkedin.com/in/krunal-bhandekar/)**

---
