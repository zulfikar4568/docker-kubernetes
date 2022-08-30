## Membuat Service
```bash
kubectl create -f nginx-service.yaml
kubectl get all
```

## Mengakses Service dari dalam Cluster
```bash
kubectl exec curl -it -- /bin/sh
curl http://cluster-ip:port/
```