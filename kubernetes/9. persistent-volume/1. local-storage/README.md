# Kubernetes Local Storage with PV, PVC, and Pod (AWS EKS)

This setup demonstrates how to use **local EC2 instance storage** as a Persistent Volume (PV) in an AWS EKS cluster. It includes:

- A `PersistentVolume` using `hostPath` on the node
- A `PersistentVolumeClaim`
- A Pod (e.g., Nginx) that uses the PVC to persist data

---

## ✅ Overview

### We will:

- Use the instance’s local storage (e.g., `/mnt/data`, or similar path).
- Create:
  - A PersistentVolume that uses hostPath.
  - A PersistentVolumeClaim that binds to the PV.
  - A Pod that uses the PVC to mount the storage.

⚠️ **hostPath volumes only work with local node storage** — suitable for single-node clusters or testing purposes. Not recommended for production/multi-node clusters.

---

## 📁 File Structure

- `pv.yml` - PersistentVolume definition
- `pvc.yml` - PersistentVolumeClaim definition
- `pod.yml` - Pod definition using PVC

---

## ⚙️ Step-by-Step Setup

### 1. Create Directory on EC2 Node

SSH into your EKS worker node (EC2 instance) and create a directory to be used as the local volume:

```bash
ssh -i <your-key.pem> ec2-user@<EC2-Public-IP>
```

```bash
sudo mkdir -p /mnt/data
```

```bash
sudo chmod 777 /mnt/data
```

---

### 2. Apply Kubernetes Manifests

Apply the Persistent Volume:

```bash
kubectl apply -f pv.yml
```

Apply the Persistent Volume Claim:

```bash
kubectl apply -f pvc.yml
```

Apply the Pod:

```bash
kubectl apply -f pod.yml
```

---

### 3. ✅ Verification

Check PVC Binding:

```bash
kubectl get pv
```

```bash
kubectl get pvc
```

It should show `STATUS: Bound`.

Check Pod:

```bash
kubectl get pods
```

Ensure the pod is `Running`.

```bash
kubectl describe pod local-storage-pod
```

---

### 4. 🧪 Test Data Persistence

1. **Exec into the Pod and Write Data**

```bash
kubectl exec -it local-storage-pod -- /bin/sh
```

inside the pod:

```bash
echo "Hello from EKS volume!" > /usr/share/nginx/html/test.txt
```

```bash
cat /usr/share/nginx/html/test.txt
```

You should see:

```bash
Hello from EKS volume!
```

Now exit:

```bash
exit
```

2. **SSH into the EC2 Node and Check the Host Path**

```bash
ssh -i <your-key.pem> ec2-user@<EC2-Public-IP>
```

Now check the contents of the directory used by the `hostPath`:

```bash
cat /mnt/data/test.txt
```

You should see:

```bash
Hello from EKS volume!
```

3. **Test Persistence After Pod Deletion**

Delete the pod and re-apply it:

```bash
kubectl delete pod local-storage-pod
```

```bash
kubectl apply -f pod.yml
```

Then again:

```bash
kubectl exec -it local-storage-pod -- cat /usr/share/nginx/html/test.txt
```

If it shows your original text, **storage is persistent and working!**

---

## 📌 Note

This setup is ideal for **single-node clusters** or **stateful edge cases** where you control node scheduling.

`hostPath` volumes are **not recommended for production** workloads in distributed/multi-node environments.

---

### 👨‍💻 Author

Maintained by **[Krunal Bhandekar](https://www.linkedin.com/in/krunal-bhandekar/)**

---
