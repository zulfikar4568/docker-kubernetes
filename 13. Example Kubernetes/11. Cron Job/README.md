Cron Job menjalankan aplikasi beberapa kali sesuai jadwal yang kita tentukan

https://crontab.guru/

## Membuat Cron Jobs
```bash
kubectl create -f node-cron-job.yaml
```

## Mengambil Cron Jobs
```bash
kubectl get all
kubectl get cronjobs

kubectl get pod
kubectl logs nodejs-cronjob-27697429-h4d7b
kubectl describe cronjobs nodejs-cronjob
```

## Menghapus Cron Jobs
```bash
kubectl delete cronjobs nodejs-cronjob
```