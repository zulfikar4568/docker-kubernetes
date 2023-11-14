## Membuat Replica Set
```bash
kubectl create -f nginx-rs.yaml
```

## Cek Replica Set
```bash
kubectl get replicasets
kubectl get replicasets
kubectl get rs
```

## test Replica Set
```bash
kubectl get pod
kubectl delete pod nginx-rs-vxpvg # Harusnya otomatis membuat pod yang baru
```

## Menghapus Replica Set
```bash
# Menghapus Replication Controller beserta pod nya
kubectl delete rc nginx-rs

# Menghapus hanya Replication Controller nya saja tanpa menghapus pod
kubectl delete rc nginx-rs --cascade=false 
```

## Match Expression
- In, value label harus ada di value in
- NotIn, value label tidak boleh ada di value in
- Exists, label harus ada
- NotExists, label tidak boleh ada
