
## Menghapus Pod
```bash
kubectl delete pod pod1 pod2 pod3
kubectl delete pod nginx
```


## Menghapus Pod dengan label
```bash
kubectl get pod --show-labels
kubectl delete pod -l team=finance 
```

## Menghapus semua pod di namespace
```bash
kubectl delete pod --all --namespace staging-environment
```