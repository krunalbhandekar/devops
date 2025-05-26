# 📘 Deployment with Environment Variables in Kubernetes

This guide demonstrates how to define and access environment variables within a Kubernetes Deployment.

---

## 📁 Files

`deployment.yaml`: Kubernetes deployment manifest with environment variables set in the container.

---

## 📦 Purpose

In many applications, you need to pass environment-specific values like API keys, database credentials, or configuration modes. Kubernetes allows you to inject such values directly into your containers as environment variables.

---

## 🚀 Apply the Deployment

```bash
kubectl apply -f deployment.yaml
```

---

## 🔍 Verify Environment Variables

**1. Get the pod name:**

```bash
kubectl get pods
```

**2. Exec into the running pod:**

```bash
kubectl exec -it <pod-name> -- printenv
```

You should see `APP_ENV`, `DB_HOST`, `DB_PORT`, etc.

---

## ✅ Use Cases

- Configuring environments (e.g., development, staging, production)
- Setting application behavior flags
- Providing database or service connection details

---

### 👨‍💻 Author

Maintained by **[Krunal Bhandekar](https://www.linkedin.com/in/krunal-bhandekar/)**

---
