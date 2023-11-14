Jika kita tidak men spesifikasi kan namespace ketika membuat pod dll, maka secara default akan di assign ke default,
Walaupun namespace berbeda namun resource masih bisa saling berkomunikasi

## Melihat namespace
```bash
kubectl get namespaces
kubectl get namespace
kubectl get ns
```

## Melihat Pod di namespace
```bash
kubectl get pod --namespace staging-environment
# atau
kubectl get pod -n staging-environment 
```

## Membuat namespace
```bash
kubectl create -f staging-namespace.yaml
```

## Membuat Pod dengan namespace
```bash
kubectl create -f nginx-staging.yaml --namespace staging-environment
```

## Menghapus namespace 
```bash
# Jika kita menghapus namespace, maka semua resource akan terhapus
kubectl delete namespace staging-environment
```