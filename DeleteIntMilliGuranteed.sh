#!/bin/bash

# Create 10 deployments with pod anti-affinity, CPU request/limit set to 1, and PVCs
for ((i=1; i<=13; i++)); do
kubectl delete -f deployment-$i.yaml
done
