##  Menambahkan Label ke node
```bash
kubectl label node minikube ssd=true
kubectl describe node minikube
```

## Jalankan dengan node-selector
```bash
kubectl create -f nginx-dengan-node-selector.yaml
```
