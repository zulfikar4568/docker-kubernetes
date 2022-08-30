## Buat Pod
```bash
kubectl create -f nginx-dengan-label.yaml
```

## Cek Pod dengan label
```bash

kubectl get pod --show -labels
```

## Menambahkan Label di Pod yang sudah berjalan
```bash
kubectl label pod nginx dev=backend
# atau di bawah ini mengubah yang sudah ada
kubectl label pod nginx dev=backend --overwrite
```

## Mencari pod dengan label
```bash
kubectl get pods -l key
kubectl get pods -l key=value
kubectl get pods -l '!key'
kubectl get pods -l key!=value
kubectl get pods -l 'key in (value, value2)'
kubectl get pods -l 'key notin (value, value2)'
```