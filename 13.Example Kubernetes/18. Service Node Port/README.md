Node Port digunakan untuk mengakses service dari luar Cluster melalui IP node
https://minikube.sigs.k8s.io/docs/handbook/accessing/

Melihat Node Port di Minikube
```bash
minikube service nama-service 
```

Jalankan Service
```bash
kubectl create -f service-nginx-node-port.yaml
minikube service nginx-service

# Buka di terminal kedua
ps -ef | grep docker@127.0.0.1
# Berikut contoh output nya maka tunnel port nya 50949
# 501 30444 30429   0  5:07PM ttys000    0:00.01 ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -N docker@127.0.0.1 -p 49414 -i /Users/zulfikar4568/.minikube/machines/minikube/id_rsa -L 50949:10.97.243.199:80
```