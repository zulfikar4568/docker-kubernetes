## Membuat Replication Controller
```bash
kubectl create -f nginx-rc.yaml
```

## Cek Replication Controller
```bash
kubectl get replicationcontrollers
kubectl get replicationcontroller
kubectl get rc
```

## test Replication Controller
```bash
kubectl get pod
kubectl delete pod nginx-rc-vxpvg # Harusnya otomatis membuat pod yang baru
```

## Menghapus Replication Controller
```bash
# Menghapus Replication Controller beserta pod nya
kubectl delete rc nginx-rc

# Menghapus hanya Replication Controller nya saja tanpa menghapus pod
kubectl delete rc nginx-rc --cascade=false 
```