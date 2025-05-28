# 💽 Kubernetes Persistent Volume Using Amazon EBS

This guide walks you through setting up **Amazon EBS** as a **Persistent Volume (PV)** in a **Kubernetes cluster on AWS**. It covers configuring the **IAM role**, enabling the **EBS CSI Driver add-on**, and deploying a **pod** that uses the EBS volume.

---

## 📌 Why Single Availability Zone?

Amazon EBS volumes are **AZ-specific**, meaning you **cannot attach an EBS volume from** `ap-south-1a` **to a node in** `ap-south-1b`.

Make sure the following all exist in the **same Availability Zone**:

- The EBS Volume
- The Persistent Volume (PV)
- The Persistent Volume Claim (PVC)
- The Pod
- The Node (that the pod schedules onto)

---

## 🎥 1. Watch Video

👉 **[Watch the Setup Video]()**

Watch the video tutorial to learn how to:

- Create an EKS Cluster
- Launch EC2 worker nodes
- Create an EBS volume

---

## 🧾 2. Create PersistentVolume (`pv.yml`)

```bash
apiVersion: v1
kind: PersistentVolume
metadata:
  name: ebs-pv
spec:
  capacity:
    storage: 5Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: manual
  awsElasticBlockStore:
    volumeID: <your-ebs-volume-id> # e.g., vol-0f1abcd1234567890
    fsType: ext4
```

🔧 Replace `<your-ebs-volume-id>` with your actual EBS volume ID.

Apply the manifest:

```bash
kubectl apply -f pv.yml
```

---

## 🧾 3. Create a Persistent Volume Claim (`pvc.yml`)

```bash
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ebs-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  resources:
    requests:
      storage: 5Gi
```

Apply the manifest:

```bash
kubectl apply -f pvc.yml
```

---

## 🚀 4. Deploy Pod with Mounted PVC (`pod.yml`)

```bash
apiVersion: v1
kind: Pod
metadata:
  name: ebs-app
spec:
  containers:
    - name: app
      image: nginx
      volumeMounts:
        - mountPath: /data
          name: ebs-volume
  volumes:
    - name: ebs-volume
      persistentVolumeClaim:
        claimName: ebs-pvc
```

Apply the manifest:

```bash
kubectl apply -f pod.yml
```

---

## ✅ 5. Verify Setup

Check PV, PVC, and Pod:

```bash
kubectl get pv
```

```bash
kubectl get pvc
```

Inspect pod:

```bash
kubectl get pods
```

Expected Output:

| NAME    | READY | STATUS  | RESTARTS | AGE |
| ------- | ----- | ------- | -------- | --- |
| ebs-app | 1/1   | Running | 0        | 15s |

```bash
kubectl describe pod ebs-app
```

---

## 📝 6. Test Volume Persistence

**Write data into the volume:**

```bash
kubectl exec -it ebs-app -- /bin/bash
```

```bash
cd /data
```

```bash
echo "EBS is working!" > test.txt
```

```bash
cat test.txt
```

Expected output:

```bash
EBS is working!
```

**Delete the pod:**

```bash
exit
```

```bash
kubectl delete pod ebs-app
```

This will remove the pod, but **not the volume** (because it's an EBS volume managed via `PersistentVolume`)

**Recreate the pod (`pod.yml`):**

```bash
kubectl apply -f pod.yml
```

Wait for the pod to come up:

```bash
kubectl get pods
```

**Check if data still exists:**

```bash
kubectl exec -it ebs-app -- /bin/bash
```

```bash
cd /data
```

```bash
cat test.txt
```

Expected output:

```bash
EBS is working!
```

✅ This confirms:

- Data is **persisted** across pod restarts.
- The EBS volume is **reattached** to the new pod.
- Your setup is functioning correctly.

---

### 👨‍💻 Author

Maintained by **[Krunal Bhandekar](https://www.linkedin.com/in/krunal-bhandekar/)**

---
