## Buat Pod
```bash
kubectl create -f nginx.yaml
```


## Cek Pod
```bash
kubectl get pod
kubectl get pod -o wide
kubectl describe pod nginx
```

## Test Pod
```bash
kubectl port-forward nginx 8888:80
```

Jalankan di browser http://localhost:8888/