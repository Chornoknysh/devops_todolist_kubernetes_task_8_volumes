# Validation Instructions for ToDo App in Kubernetes

## 1. Deploy the resources
```
./bootstrap.sh
```
Or manually:
```
kubectl apply -f pv.yml
kubectl apply -f pvc.yml
kubectl apply -f deployment.yml
```
2. Verify PV and PVC
```
kubectl get pv todo-pv
kubectl get pvc todo-pvc -n todoapp
```
Expected:

todo-pv → STATUS: Bound

todo-pvc → STATUS: Bound

Details:
```
kubectl describe pv todo-pv
kubectl describe pvc todo-pvc -n todoapp
```
3. Verify Pod status
```
kubectl get pods -n todoapp -l app=todoapp
kubectl describe pod -n todoapp <POD_NAME>
```
Pod should be in Running state.
Optional logs:
```
kubectl logs -n todoapp <POD_NAME>
```
4. Verify ConfigMap mount
````
kubectl exec -n todoapp -it <POD_NAME> -- ls -la /app/configs
kubectl exec -n todoapp -it <POD_NAME> -- cat /app/configs/<key>
````
Files from app-config should exist and be read-only (-r--r--r--).

5. Verify Secret mount
```
kubectl exec -n todoapp -it <POD_NAME> -- ls -la /app/secrets
kubectl exec -n todoapp -it <POD_NAME> -- cat /app/secrets/SECRET_KEY
```
Files from app-secret should exist and be read-only (-r--------).

6. Verify PersistentVolumeClaim
```
kubectl exec -n todoapp -it <POD_NAME> -- ls -la /app/data
kubectl exec -n todoapp -it <POD_NAME> -- sh -c "echo 'hello' > /app/data/test.txt && cat /app/data/test.txt"
```
Expected output: hello → volume is working.

7. Troubleshooting
If PVC is not Bound:

```
kubectl describe pvc todo-pvc -n todoapp
kubectl describe pv todo-pv
```
If ConfigMap or Secret files are missing → double-check names app-config and app-secret.