# 🛡️ Kubernetes Ingress Setup on AWS EKS for Static HTML Pages

This guide walks you through deploying two static HTML pages (`home.html` and `mobile.html`) on **AWS EKS** using **Kubernetes Ingress**, leveraging **AWS CloudShell** and the **AWS Console**.

---

## ✅ Prerequisites

- AWS Account
- EKS Cluster with `kubectl` configured
- DockerHub or AWS ECR account
- Basic understanding of Docker and Kubernetes
- AWS CLI and `kubectl` available via AWS CloudShell

---

## 📁 Project Structure

```bash
├── docker
│   ├── home
│   │   ├── Dockerfile
│   │   ├── home.html
│   │   └── deployment.yml
│   └── mobile
│       ├── Dockerfile
│       ├── mobile.html
│       └── deployment.yml
└── ingress
    └── ingress.yml
```

---

## 🚀 Step 1: Create an EKS Cluster (via AWS Console)

👉 **[Watch the EKS Cluster Setup Video](https://drive.google.com/file/d/1xZGNourGj8O7jQJuzwy-7SVm74DYC_jB/view?usp=sharing)**

Once your cluster is created, configure `kubectl` using:

```bash
aws eks update-kubeconfig --region <your-region>  --name <your-cluster-name>
```

**Example:**

```bash
aws eks update-kubeconfig --region ap-south-1 --name cluster-ingress
```

---

## 🌐 Step 2: Install NGINX Ingress Controller

Apply the NGINX ingress controller:

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.4/deploy/static/provider/aws/deploy.yaml
```

Check if the controller is running:

```bash
kubectl get pods -n ingress-nginx
```

---

## 📦 Step 3: Build & Push Docker Images (AWS CloudShell)

Login to Docker:

```bash
docker login
```

**🏠 Home Pagee**

```bash
cd docker/home
```

```bash
docker build -t my-home -f Dockerfile .  ## or docker build -t my-home .
```

```bash
docker tag my-home <your-dockerhub-username>/my-home
```

```bash
docker push <your-dockerhub-username>/my-home
```

**📱 Mobile Page**

```bash
cd
```

```bash
cd docker/mobile
```

```bash
docker build -t my-mobile -f Dockerfile . ## or docker build -t my-mobile .
```

```bash
docker tag my-mobile <your-dockerhub-username>/my-mobile
```

```bash
docker push <your-dockerhub-username>/my-mobile
```

---

## ⚙️ Step 4: Deploy to Kubernetes

Edit both `deployment.yml` files and replace the image with:

```bash
image: <your-dockerhub-username>/my-home
```

and

```bash
image: <your-dockerhub-username>/my-mobile
```

replace `<your_dockerhub_username>` with **your dockerhub username**

Then apply them:

```bash
cd
```

```bash
kubectl apply -f docker/home/deployment.yml
```

```bash
kubectl apply -f docker/mobile/deployment.yml
```

---

## 🌐 Step 5: Create Ingress Resource

Apply the Ingress configuration:

```bash
kubectl apply -f ingress/ingress.yml
```

---

## 🔗 Step 6: Access Your Web Pages

Get the Ingress external IP:

```bash
kubectl get ingress
```

You'll see an address like:

| NAME         | CLASS | HOSTS | ADDRESS                                                                              | PORTS | AGE |
| ------------ | ----- | ----- | ------------------------------------------------------------------------------------ | ----- | --- |
| html-ingress | nginx | \*    | **`a29f77032a45848e7afa19969c6057e8-23cb952f5dcd1f7e.elb.ap-south-1.amazonaws.com`** | 80    | 1m  |

Open in browser:

- http://<ELB-DNS>/home.html
- http://<ELB-DNS>/mobile.html

Example:

- http://a29f77032a45848e7afa19969c6057e8-23cb952f5dcd1f7e.elb.ap-south-1.amazonaws.com/home.html
- http://a29f77032a45848e7afa19969c6057e8-23cb952f5dcd1f7e.elb.ap-south-1.amazonaws.com/mobile.html

---

### 👨‍💻 Author

Maintained by **[Krunal Bhandekar](https://www.linkedin.com/in/krunal-bhandekar/)**

---
