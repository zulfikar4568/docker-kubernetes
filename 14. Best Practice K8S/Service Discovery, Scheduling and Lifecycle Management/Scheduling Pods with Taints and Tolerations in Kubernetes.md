# Scheduling Pods with Taints and Tolerations in Kubernetes
![image](https://github.com/zulfikar4568/docker-kubernetes/assets/64786139/43f0ab1b-2df6-49eb-81c4-c43dde8384f2)

Within that cluster, we must perform the following tasks to taint the production node in order to repel work. We will create the necessary taint to properly label one of the nodes “prod.” Then, we will deploy two pods — one to each environment. One pod spec will contain the toleration for the taint.

Objective:
- Taint one of the worker nodes to repel work.
- Schedule a pod to the dev environment.
- Allow a pod to be scheduled to the prod environment.
- Verify each pod has been scheduled and verify the toleration.

## Taint one of the worker nodes to repel work.

1. List out the nodes:
```bash
kubectl get nodes
```

2. Taint the node, replacing <NODE_NAME> with one of the worker node names returned in the previous command:
```bash
kubectl taint node <NODE_NAME> node-type=prod:NoSchedule
```

## Schedule a pod to the dev environment.

1. Create the dev-pod.yaml file:
```bash
vim dev-pod.yaml
```
2. Enter the following YAML to specify a pod that will be scheduled to the dev environment:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: dev-pod
  labels:
    app: busybox
spec:
  containers:
  - name: dev
    image: busybox
    command: ['sh', '-c', 'echo Hello Kubernetes! && sleep 3600']
```

4. Save and quit the file by pressing Escape followed by wq!.

5. Create the pod:
```bash
kubectl create -f dev-pod.yaml
```

## Schedule a pod to the prod environment.
1. Create the prod-deployment.yaml file:
```bash
vim prod-deployment.yaml
```

2. Enter the following YAML to specify a pod that will be scheduled to the prod environment:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prod
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prod
  template:
    metadata:
      labels:
        app: prod
    spec:
      containers:
      - args:
        - sleep
        - "3600"
        image: busybox
        name: main
      tolerations:
      - key: node-type
        operator: Equal
        value: prod
        effect: NoSchedule
```

3. Save and quit the file by pressing Escape followed by wq!.

4. Create the pod:
```bash
kubectl create -f prod-deployment.yaml
```

## Verify each pod has been scheduled to the correct environment.
1. Verify the pods have been scheduled:
```bash
kubectl get pods -o wide
```
2. Scale up the deployment:
```bash
kubectl scale deployment/prod --replicas=3
```
3. Look at our deployment again:
```bash
kubectl get pods -o wide
```
4. We should see that two more pods have been deployed.
