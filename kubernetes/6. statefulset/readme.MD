# 🧱 Kubernetes StatefulSet without Persistent Storage

This project demonstrates how to create a Kubernetes StatefulSet **without using Persistent Volume Claims (PVCs)** — useful for learning and testing purposes.

---

## 📦 What’s Included

- A **StatefulSet** running NGINX replicas
- A **headless Service** for stable network identities
- Deployed in a custom **namespace**: `sss-ns`
- No persistent volumes used (ephemeral setup)

---

## 📄 YAML Overview (sss.yml)

Here’s a quick look at what’s inside the YAML:

Headless Service (`sss-service`):

- Enables DNS for StatefulSet
- Uses `clusterIP: None`

StatefulSet (`my-sss`):

- Runs 2 replicas of NGINX
- Uses stable network identities (`my-sss-0.sss-service`, etc.)
- No volumes or PVCs

---

## 🧾 Prerequisites

- A working Kubernetes cluster (e.g., on AWS EKS or Minikube)
- `kubectl` configured and pointing to your cluster

---

## 🚀 Setup Instructions

### 1. Create a Namespace

```bash
kubectl create namespace sss-ns
```

### 2. Apply the YAML

```bash
kubectl apply -f sss.yml
```

**Or if you didn't specify the namespace in YAML:**

```bash
kubectl apply -f sss.yml -n sss-ns
```

### 3. Verify Resources

```bash
kubectl get all -n sss-ns
```

You should see the StatefulSet pods (`my-sss-0`, `my-sss-1`, etc.) running.

### 4. Check StatefulSet

- **List StatefulSets:**

```bash
kubectl get statefulsets -n sss-ns
```

- **Describe StatefulSet:**

```bash
kubectl describe statefulset my-sss -n sss-ns
```

- **Check pods created by StatefulSet:**

```bash
kubectl get pods -n sss-ns
```

You will see pods with names like `my-sss-0`, `my-sss-1`, etc., showing that the pods created with stable identities.

---

### ✅ Use Cases:

- Learning and practicing StatefulSets
- Networking behavior of StatefulSets without persistent data
- Lightweight demos or test environments

---

### 📌 Notes:

- StatefulSets maintain **sticky identities** for pods (useful for databases).
- Requires a **Headless Service** (`clusterIP: None`) if you need stable network identities.

---

### 👨‍💻 Author

Maintained by **[Krunal Bhandekar](https://www.linkedin.com/in/krunal-bhandekar/)**

---
