Job merupakan object pada kubernetes yang dijalankan sekali kali saja

Contoh jika kita men set:
```yaml
  completions: 4
  parallelism: 2
```
Maka Job akan membuat pod 2 buah, dan di jalankan 2 kali karena completions nya 4

## Membuat Daemon Set
```bash
kubectl create -f node-job.yaml
```

## Check job
```bash
kubectl get jobs
kubectl describe jobs nodejs-job
kubectl get all
```

## Menghapus job
```bash
kubectl delete jobs nodejs-job 
```