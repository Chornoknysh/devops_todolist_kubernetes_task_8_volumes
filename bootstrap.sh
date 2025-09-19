#!/usr/bin/env bash
set -euo pipefail

INFRA_DIR=".infrastructure"
NAMESPACE="todoapp"

echo "Ensuring namespace '${NAMESPACE}' exists..."
kubectl create namespace "${NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -

echo "Applying PersistentVolume..."
kubectl apply -f "${INFRA_DIR}/pv.yml"

echo "Applying PersistentVolumeClaim..."
kubectl apply -f "${INFRA_DIR}/pvc.yml" -n "${NAMESPACE}"

echo "Waiting for PVC to be Bound..."
kubectl wait --for=condition=Bound pvc/todo-pvc --timeout=60s -n "${NAMESPACE}"

echo "Applying ConfigMap..."
kubectl apply -f "${INFRA_DIR}/configmap.yml" -n "${NAMESPACE}"

echo "Applying Secret..."
kubectl apply -f "${INFRA_DIR}/secret.yml" -n "${NAMESPACE}"

echo "Applying Deployment..."
kubectl apply -f "${INFRA_DIR}/deployment.yml" -n "${NAMESPACE}"

echo "Waiting for deployment rollout..."
kubectl rollout status deployment/todoapp -n "${NAMESPACE}"

echo "All resources applied successfully."
echo "Check resources with:"
echo "  kubectl get pv,pvc,pods -n ${NAMESPACE} -o wide"
