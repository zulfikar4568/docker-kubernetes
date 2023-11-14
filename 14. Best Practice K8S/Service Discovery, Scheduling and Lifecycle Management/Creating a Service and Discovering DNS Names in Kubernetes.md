# Creating a Service and Discovering DNS Names in Kubernetes

We have been given a three-node cluster. Within that cluster, we must perform the following tasks in order to create a service and resolve the DNS names for that service. We will create the necessary Kubernetes resources in order to perform this DNS query.

To adequately complete this hands-on lab, we must have a working deployment, a working service, and be able to record the DNS name of the service within our Kubernetes cluster.

## Create an nginx deployment, and verify it was successful.
1. Use this command to create an nginx deployment:
```bash
kubectl run nginx --image=nginx
```
2. Use this command to verify deployment was successful:
```bash
kubectl get deployments
```

## Create a service, and verify the service was successful.
1. Use this command to create a service:
```bash
kubectl expose deployment nginx --port 80 --type NodePort
```
2. Use this command to verify the service was created:
```bash
kubectl get services
```

## Create a pod that will allow you to query DNS, and verify it’s been created.
1. Using an editor of your choice (e.g., Vim and the command vim busybox.yaml), enter the following YAML to create the busybox pod spec:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox
spec:
  containers:
  - image: busybox:1.28.4
    command:
      - sleep
      - "3600"
    name: busybox
  restartPolicy: Always
```
2. Use the following command to create the busybox pod:
```bash
kubectl create -f busybox.yaml
```
3. Use the following command to verify the pod was created successfully:
```bash
kubectl get pods
```

## Perform a DNS query to the service.
1. Use the following command to query the DNS name of the nginx service:
```bash
kubectl exec busybox -- nslookup nginx
```
## Record the DNS name.
1. Record the name of:
```bash
[service-name].default.svc.cluster.local
```