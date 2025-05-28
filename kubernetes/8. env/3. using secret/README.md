# 🔐 Kubernetes Secrets with Deployment (Environment Variables)

This guide explains how to securely inject sensitive data (like passwords or API keys) into your Kubernetes pods using **Secrets** and consume them as **environment variables** in your deployments.

---

## 📁 Files Included

- `secret.yaml`: Defines the Kubernetes Secret with base64-encoded values.
- `deployment.yaml`: A sample Deployment that uses the secret as environment variables.

---

## ✅ Step-by-Step Instructions

### 1. Create the Kubernetes Secret

Use `secret.yaml` to define the secret data (make sure values are base64-encoded):

```bash
# secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
type: Opaque
data:
  DB_PASSWORD: cGFzc3dvcmQxMjM=       # base64 for "password123"
  API_KEY: YXBpX2tleV92YWx1ZQ==        # base64 for "api_key_value"
```

- 💡 Use `echo -n 'your-value' | base64` to generate base64 values

eg:

```bash
echo -n 'password123' | base64
```

Apply the secret:

```bash
kubectl apply -f secret.yaml
```

### 2. Create Deployment that Uses the Secret

Define a deployment in `deployment.yaml` that consumes the secret:

```bash
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: secret-env-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: secret-app
  template:
    metadata:
      labels:
        app: secret-app
    spec:
      containers:
        - name: app
          image: nginx
          env:
            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: my-secret
                  key: DB_PASSWORD
            - name: API_KEY
              valueFrom:
                secretKeyRef:
                  name: my-secret
                  key: API_KEY
```

Apply the deployment:

```bash
kubectl apply -f deployment.yaml
```

### 3. Verify the Secrets Inside the Pod

List pods:

```bash
kubectl get pods
```

Check the environment variables inside the pod:

```bash
kubectl exec -it <pod-name> -- printenv | grep DB_PASSWORD
kubectl exec -it <pod-name> -- printenv | grep API_KEY
```

Expected output:

```bash
DB_PASSWORD=password123
API_KEY=api_key_value
```

---

## 🔒 Best Practices

- Always use **`Secrets`** for sensitive data.
- Never commit raw secrets or plaintext values to Git repositories.
- Use tools like **Sealed Secrets** or **Vault** for extra security in CI/CD pipelines.

---

## 🧠 Summary

| Type       | Use Case                  | Secure?  |
| ---------- | ------------------------- | -------- |
| Plain env  | Basic config              | ❌ No    |
| Secret env | Passwords, API keys, etc. | ✅ Yes   |
| ConfigMap  | Public config values      | ✔️ Maybe |

---

### 👨‍💻 Author

Maintained by **[Krunal Bhandekar](https://www.linkedin.com/in/krunal-bhandekar/)**

---
