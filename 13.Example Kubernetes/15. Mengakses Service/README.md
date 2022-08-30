## Menggunakan ENV variable
```bash
kubectl exec curl -- env

# atau masuk kedalam pod:
kubectl exec curl -it -- /bin/sh
env
# Lalu gunakan NGINX_SERVICE_SERVICE_HOST
# Lalu gunakan NGINX_SERVICE_SERVICE_PORT 
```


## Menggunakan DNS
```bash
# nama-service.nama-namespace.svc.cluster.local 
kubectl exec curl -it -- /bin/sh
curl http://nginx-service.default.svc.cluster.local:8080
```

Melihat endpoint
```
kubectl get endpoints
```