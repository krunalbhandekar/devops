# Kubernetes DaemonSet Example

This project demonstrates how to create and use a **DaemonSet** in Kubernetes to deploy a pod on every node in the cluster.

---

## 🧾 What is a DaemonSet?

A **DaemonSet** ensures that a specific pod runs **on all (or selected) nodes** in a Kubernetes cluster. It is commonly used to run system services like log collectors, monitoring agents, or networking plugins.

---

### 1. Create a Namespace

```bash
kubectl create namespace dmn-ns
```

---

### 2. Apply the DaemonSet Manifest

```bash
kubectl apply -f dmn.yml
```

### 3. Verify the DaemonSet

**Check the DaemonSet:**

```bash
kubectl get daemonsets -n dmn-ns
```

**Check the pods created:**

```bash
kubectl get pods -o wide
```

```bash
kubectl get pods -n dmn-ns -o wide
```

```bash
kubectl get pods -o wide -l name=my-dmn -n dmn-ns
```

**Check the Nodes:**

```bash
kubectl get nodes -o wide
```

**Describe the DaemonSet**

```bash
kubectl describe daemonset my-dmn -n dmn-ns
```

---

### ✅ Use Cases

- Node monitoring (e.g., Prometheus Node Exporter)
- Centralized log collection (e.g., Fluentd, Filebeat)
- Security auditing (e.g., Falco)
- Network configuration (e.g., Calico)

---

### 🧠 Tips

- DaemonSet automatically adds pods to **new nodes**.
- Pods are removed if a node leaves the cluster.
- Use `nodeSelector`, `affinity`, or `tolerations` to control node targeting.

### 👨‍💻 Author

Maintained by **[Krunal Bhandekar](https://www.linkedin.com/in/krunal-bhandekar/)**

---
