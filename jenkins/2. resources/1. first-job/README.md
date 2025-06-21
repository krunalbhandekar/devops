# 🚀 Jenkins Job: Build from Git Repository with Custom Script with Ubuntu server

This guide explains how to create a new Jenkins job that pulls code from a Git repository and executes a custom shell script.

---

## 🧰 Prerequisites

- Jenkins installed and running (`http://<server-public-ip>:8080`)
- Jenkins user with necessary permissions
- Git installed on the server:

```bash
sudo apt install git -y         # Ubuntu/Debian
```

---

## 📁 Step-by-Step Guide

### 🔧 Step 1: Install Git Plugin (if not installed)

- Open **Jenkins Dashboard**
- Navigate to **Manage Jenkins > System Configuration > Plugins > Available**.
- Search for **Git** Plugin.
- Install it and restart Jenkins if prompted.

### 🆕 Step 2: Create a New Jenkins Job

- Click **"New Item"** from the Jenkins Dashboard.
- Enter a name for your job (e.g., `My-Git-Job`)
- Select **Freestyle Project**.
- Click **OK**.

### 🌐 Step 3: Configure Git Repository

- In the Source **Code Management** section, choose **Git**.
- Enter your Git repository URL:

```bash
https://github.com/<username>/<repo-name>.git
```

- If it's a private repo, add credentials:
  - Click **Add** next to **Credentials**
  - Choose type (e.g., Username/Password or SSH key)
  - Save and select them from the dropdown
- Enter your branch (**master/main**)

### 📝 Step 4: Add Build Step – Custom Shell Script

- Scroll down to **Build** section.
- Click **Add build step → Execute shell**.
- Paste your script, for example:

```bash
echo "Build Started"

# Navigate to project folder (optional, Jenkins pulls into workspace)
cd $WORKSPACE

ls

echo "Build Finished"
```

### ▶️ Step 5: Save and Run the Job

- Click **Save**
- Click **Build Now** (from the left menu)
- Monitor build progress under **Build History**
- Click on build → **Console Output** to view logs

---

## 🧪 Notes

- `$WORKSPACE` is the Jenkins directory for your job (e.g., `/var/lib/jenkins/workspace/My-Git-Job`)

---

### 👨‍💻 Author

Maintained by **[Krunal Bhandekar](https://www.linkedin.com/in/krunal-bhandekar/)**

---
