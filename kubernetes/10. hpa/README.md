# Kubernetes Horizontal Pod Autoscaler (HPA) Demo on AWS EKS using AWS CloudShell

This guide demonstrates how to deploy a Kubernetes Deployment with **Horizontal Pod Autoscaler (HPA)** on **AWS EKS** and testing it by generating CPU stress using the `stress` tool inside a pod.

---

## 📋 Prerequisites

- AWS account with **EKS** access and an existing **EKS cluster + node group**.
- AWS **CloudShell** (pre-configured with `kubectl` & `eksctl`).
- **Metrics Server** installed on the cluster.
  Install with:

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

---

## 🚀 Deploy Resources

Apply the deployment and HPA manifests:

```bash
kubectl apply -f deployment.yml
```

```bash
kubectl apply -f hpa.yml
```

---

## ✅ Verify Deployment & HPA

Check HPA status:

```bash
kubectl get hpa
```

Example output:

| NAME | REFERENCE                 | CPU TARGET | MIN PODS | MAX PODS | REPLICAS | AGE |
| ---- | ------------------------- | ---------- | -------- | -------- | -------- | --- |
| hpa  | Deployment/hpa-deployment | 0% / 50%   | 1        | 5        | 1        | 46m |

Check deployment status:

```bash
kubectl get deployment
```

Example output:

| NAME           | READY | UP-TO-DATE | AVAILABLE | AGE |
| -------------- | ----- | ---------- | --------- | --- |
| hpa-deployment | 1/1   | 1          | 1         | 46m |

Check running pods:

```bash
kubectl get pods
```

Example output:

| NAME                            | READY | STATUS  | RESTARTS | AGE   |
| ------------------------------- | ----- | ------- | -------- | ----- |
| hpa-deployment-5d5ff958f7-hd8jm | 1/1   | Running | 0        | 7m25s |

---

## 🛠 Generate CPU Load with stress

Get the pod name:

```bash
kubectl get pods
```

Exec into the pod (replace with actual pod name):

```bash
kubectl exec -it <pod-name> -- bash
```

Inside the container, install `stress` and generate CPU load:

```bash
apt update && apt install stress
```

```bash
stress --cpu 80 --timeout 10m &
```

Wait ~1 minute for load to affect metrics, then exit the pod:

```bash
exit
```

---

## 📊 Monitor Autoscaling

Check pod resource usage:

```bash
kubectl top pods
```

You should see additional pods being created as CPU usages increses.

**eg:**

| NAME                              | CPU(cores) | MEMORY(bytes) |
| --------------------------------- | ---------- | ------------- |
| `hpa-deployment-5d5ff958f7-czqjj` | 0m         | 2mi           |
| `hpa-deployment-5d5ff958f7-ghsdh` | 0m         | 2mi           |
| `hpa-deployment-5d5ff958f7-hd8jm` | **199m**   | **43mi**      |
| `hpa-deployment-5d5ff958f7-j449f` | 0m         | 2mi           |

Watch HPA scale up/down events live:

```bash
kubectl get hpa -w
```

You should see replicas increase when CPU usage exceeds the target, then scale down once load subsides.

| NAME | REFERENCE                 | CPU TARGET | MIN PODS | MAX PODS | CURRENT REPLICAS | AGE |
| ---- | ------------------------- | ---------- | -------- | -------- | ---------------- | --- |
| hpa  | Deployment/hpa-deployment | 50% / 50%  | 1        | 5        | 4                | 14m |
| hpa  | Deployment/hpa-deployment | 49% / 50%  | 1        | 5        | 4                | 15m |
| hpa  | Deployment/hpa-deployment | 50% / 50%  | 1        | 5        | 4                | 16m |
| hpa  | Deployment/hpa-deployment | 49% / 50%  | 1        | 5        | 4                | 17m |
| hpa  | Deployment/hpa-deployment | 50% / 50%  | 1        | 5        | 4                | 18m |
| hpa  | Deployment/hpa-deployment | 49% / 50%  | 1        | 5        | 4                | 18m |
| hpa  | Deployment/hpa-deployment | 50% / 50%  | 1        | 5        | 4                | 18m |
| hpa  | Deployment/hpa-deployment | 30% / 50%  | 1        | 5        | 4                | 20m |
| hpa  | Deployment/hpa-deployment | 0% / 50%   | 1        | 5        | 4                | 20m |
| hpa  | Deployment/hpa-deployment | 0% / 50%   | 1        | 5        | 4                | 25m |
| hpa  | Deployment/hpa-deployment | 0% / 50%   | 1        | 5        | 3                | 25m |
| hpa  | Deployment/hpa-deployment | 0% / 50%   | 1        | 5        | 1                | 25m |

---

## ✅ Clean Up

```bash
kubectl delete -f hpa.yml
```

```bash
kubectl delete -f deployment.yml
```

---

## ⚠️ Notes

- Ensure **Metrics Server** is running for HPA to function.
- Scaling up pods can take a few moments on EKS.
- Adjust CPU target and max pods in `hpa.yml` to suit your needs.

---

### 👨‍💻 Author

Maintained by **[Krunal Bhandekar](https://www.linkedin.com/in/krunal-bhandekar/)**

---
