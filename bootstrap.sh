#!/usr/bin/env bash
set -euo pipefail
kubectl apply -f .infrastructure/namespace.yml
kubectl wait --for=condition=Bound pvc/todo-pvc -n todoapp --timeout=60s

echo "Applying PersistentVolume..."
kubectl apply -f .infrastructure/pv.yml

echo "Applying PersistentVolumeClaim..."
kubectl apply -f .infrastructure/pvc.yml

echo "Applying Deployment..."
kubectl apply -f .infrastructure/deployment.yml

echo "All resources applied."
echo "Run 'kubectl get pv,pvc,pods -o wide' to check status."
