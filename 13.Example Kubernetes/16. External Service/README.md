Biasanya Service digunakan sebagai gateway untuk internal Pod
Tapi Service juga bisa digunakan sebagai gateway untuk aplikasi eksternal yang berada diluar kubernetes cluster.

Service External bisa menggunakan Domain atau malalui Endpoint

## Melihat endpoint
```
kubectl describe service namaservice
kubectl get endpoints namaservice
```

## Test External Service
```bash
kubectl create -f external-service-domain.yaml
kubectl exec curl -it -- /bin/sh
curl http://example-service.default.svc.cluster.local
```