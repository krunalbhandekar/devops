# 📘 Using ConfigMap to Store Environment Variables in Kubernetes

This guide shows how to create and use a **ConfigMap** in a Kubernetes deployment to manage environment variables.

---

### 🧾 1. Create an Environment File

Create a file called `app-config.env`:

```bash
APP_ENV=prod
DB_HOST=my-database
```

---

### ⚙️ 2. Create a ConfigMap from the Env File

```bash
kubectl create configmap my-config --from-env-file=app-config.env
```

✅ This will create a ConfigMap named `my-config`.

---

### 🔍 3. Verify the ConfigMap

```bash
kubectl describe configmap my-config -o yaml
```

You should see your environment variables listed under `Data`.

---

### 📦 4. Use ConfigMap in a Deployment

Here’s an example deployment YAML (`deployment.yml`) that uses `my-config`:

```bash
    spec:
      containers:
        - name: my-app-container
          image: nginx
          envFrom:
            - configMapRef:
                name: my-config
```

Apply it using:

```bash
kubectl apply -f deployment.yml
```

---

### 🧪 5. Check the Environment Variables in the Pod

Get the pod name:

```bash
kubectl get pods
```

Then:

```bash
kubectl exec -it <pod-name> -- printenv
```

You should see `APP_ENV=prod`, `DB_HOST=my-db`, etc.

---

### 🧹 6. Update or Delete the ConfigMap

To Update:

```bash
kubectl create configmap my-config --from-env-file=app-config.env -o yaml --dry-run=client | kubectl apply -f -
```

To Delete and Recreate:

```bash
kubectl delete configmap my-config
```

```bash
kubectl create configmap my-config --from-env-file=app-config.env
```

To Edit manually:

```bash
kubectl edit configmap my-config
```

---

### 📎 Notes

- If the ConfigMap already exists, use `kubectl apply` or delete and recreate it.
- ConfigMap values are plain text and **not meant for sensitive data** — use **Secrets** for that.

---

### 👨‍💻 Author

Maintained by **[Krunal Bhandekar](https://www.linkedin.com/in/krunal-bhandekar/)**

---
