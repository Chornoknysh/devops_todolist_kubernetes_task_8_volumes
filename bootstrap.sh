#!/usr/bin/env bash
set -euo pipefail

echo "Applying PersistentVolume..."
kubectl apply -f pv.yml

echo "Applying PersistentVolumeClaim..."
kubectl apply -f pvc.yml

echo "Applying Deployment..."
kubectl apply -f deployment.yml

echo "All resources applied."
echo "Run 'kubectl get pv,pvc,pods -o wide' to check status."
