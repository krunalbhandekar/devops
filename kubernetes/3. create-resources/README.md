# Kubernetes YAML Examples – Pods, ReplicationController, ReplicaSet, and Service

This repository demonstrates how to deploy and manage applications using basic Kubernetes objects:

- **Pod**
- **ReplicationController**
- **ReplicaSet**
- **Service**

Each object is defined in a YAML file and explained in detail below.

---

## 📁 Files Overview

| File          | Description                                     |
| ------------- | ----------------------------------------------- |
| `pod.yml`     | Defines a single Pod named pod                  |
| `service.yml` | Exposes Pods matching label using a NodePort    |
| `rc.yml`      | Creates and manages 3 replicas of a Pod (RC)    |
| `rs.yml`      | Creates and manages 3 replicas using ReplicaSet |

---

## 📦 `pod.yml` – Create a Standalone Pod

**▶️ Apply:**

```bash
kubectl apply -f pod.yml
```

**🔍 Description:**

> - Creates a single Pod named `pod`.
> - Uses `nginx:1.14.2` image.
> - Exposes port `80`.
> - Adds a label `app: my-label` (useful for Service selector).

---

### 🌐 `service.yml` – Expose Pods via NodePort

**▶️ Apply:**

```bash
kubectl apply -f service.yml
```

**🔍 Description::**

> - Exposes all Pods with label `app: my-label` on a NodePort.
> - Load balances traffic to all matching Pods on port `80`.
> - Access from outside using:

```bash
kubectl get svc service
```

---

### 🔁 `rc.yml` – ReplicationController (Legacy)

**▶️ Apply:**

```bash
kubectl apply -f rc.yml
```

**🔍 Description:**

> - Creates 3 Pods named `rc-xxxxx`.
> - Ensures exactly 3 replicas are always running.
> - All Pods have label `app: my-label`, so they're targeted by my-service.

**🛑 To Stop:**

```bash
kubectl scale rc rc --replicas=0
```

or

```bash
kubectl delete rc rc
```

---

### 🔁 `rs.yml` – ReplicaSet (Modern Replacement for RC)

**▶️ Apply:**

```bash
kubectl apply -f rs.yml
```

**🔍 Description::**

> - Creates 3 Pods named `rs-xxxxx` with label `app: my-label`.
> - Maintains desired replicas automatically.
> - Recommended over ReplicationController.

**✅ Use a Service with matching selector:**

```bash
selector:
    matchLabels:
        app: my-label
```

**🛑 To Stop:**

```bash
kubectl scale rs rs --replicas=0
```

or

```bash
kubectl delete rs rs
```

---

### 🧪 Verify Everything

```bash
kubectl get pods
```

```bash
kubectl get rs
```

```bash
kubectl get rc
```

```bash
kubectl describe svc service
```

```bash
kubectl get endpoints service
```

```bash
kubectl get svc
```

Above command will give **Service Port (between 30000 to 32768)**
🔐 Allow **Service Port** in **AWS EC2 Security Group**

```bash
kubectl get nodes -o wide
```

Above command will give **External IP**

```bash
http://<external ip>:<service port>
```

---

### 📌 Notes

> - **Do not use both RC and RS for same purpose** in production — use **ReplicaSet or Deployment**.
> - ReplicaSet and RC will **replace deleted Pods automatically**.
> - Services **must match labels** defined in Pods (via RC or RS).

### 👨‍💻 Author

Maintained by **[Krunal Bhandekar](https://www.linkedin.com/in/krunal-bhandekar/)**
