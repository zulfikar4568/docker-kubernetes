## Masalah Node Port dan Load Balancer
- Jika menggunakan NodePort
  - maka semua Node harus terekspos ke public
  - client harus tau semua ip address semua Node
- Jika menggunakan LoadBalancer
  - maka semua LoadBalancer harus terekspos ke public.
  - client harus tau semua ip address semua LoadBalancer


## Ingress
- Ingress adalah salah satu cara yang bisa digunakan untuk mengekspos Service.
- Berbeda dengan LoadBalancer atau NodePort, jika menggunakan Ingress, client hanya butuh tahu satu lokasi ip adddress Ingress
- Ketika client melakukan request ke Ingress, pemilihan service nya ditentukan menggunakan hostname dari request
- Ingress hanya mendukung protocol HTTP

## Ingress di Minikube
```bash
minikube addons list
minikube addons enable ingress

kubectl get namespaces
kubectl get all --namespace ingress-nginx
```

## Membuat Ingress
```bash
kubectl create -f service-nginx-ingress.yaml
```

## Melihat semua Ingress
```bash
kubectl get ingresses
```

## Menghapus Ingress
```bash
kubectl delete ingresses nginx-ingress
```

## Melihat IP Minikube
```bash
minikube ip
```

## Set di file host kita sesuai dengan host ingress
edit file di /etc/hosts

Ingress Minikube driver docker hanya support di linux