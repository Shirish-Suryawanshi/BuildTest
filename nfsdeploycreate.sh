
#!/bin/bash

# Create 15 deployments with pod anti-affinity, CPU request/limit set to 1, and PVCs
for ((i=1; i<=15; i++)); do
cat <<EOF > deployment-$i.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nfs-pvc-$i
  namespace: nfs
  annotations:
   robin.io/nfs-server-type: "exclusive"
   robin.io/faultdomain: "host"
   robin.io/replication: "2"
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
---      
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nfs-deployment-$i
  namespace: nfs
spec:
  replicas: 2
  selector:
    matchLabels:
      app: app-$i
  template:
    metadata:
      labels:
        app: app-$i
    spec:
      containers:
      - name: app
        image: nginx:latest
        resources:
          requests:
            memory: "256Mi"
            cpu: "1"
          limits:
            memory: "512Mi"
            cpu: "1"
        volumeMounts:
        - mountPath: /nfspath
          name: v2  
      volumes:
      - name: v2
        persistentVolumeClaim:
            claimName: nfs-pvc-$i
EOF
done
