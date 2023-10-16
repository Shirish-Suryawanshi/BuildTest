
#!/bin/bash

# Create 5 deployments with Guranteed pods with Integer and milli core requests
for ((i=1; i<=6; i++)); do
cat <<EOF > deployment-$i.yaml      
apiVersion: v1
kind: Pod
metadata:
  name: guaranteed-pod-integer$i
  namespace: affinity 
  annotations:
    robin.io/robinrpool: default
spec:
  containers:
  - name: nginx
    image: registry.k8s.io/nginx-slim:0.8
    resources:
      limits:
        cpu: $i
        memory: 200Mi
      requests:
        cpu: $i
        memory: 200Mi
---
apiVersion: v1
kind: Pod
metadata:
  name: guaranteed-pod-millicore$i
  namespace: affinity
  annotations:
    robin.io/robinrpool: default
spec:
  containers:
  - name: nginx
    image: registry.k8s.io/nginx-slim:0.8
    resources:
      limits:
        cpu: 6550m
        memory: 200Mi
      requests:
        cpu: 6550m
        memory: 200Mi
EOF
done
