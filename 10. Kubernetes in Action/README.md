![components-of-kubernetes](./components-of-kubernetes.svg)

# Install Kubectl (Kube Control)
Kubectl is used for send the command instruction to our kubernetes cluster
[Kubernetes Official](https://kubernetes.io/docs/tasks/tools/)

For example, Using homebrew MacOS M1:
```bash
brew install kubectl
```

Check if kubectl has been installed
```bash
kubectl version -o=yaml
```
The response is
```
clientVersion:
  buildDate: "2022-05-03T13:36:49Z"
  compiler: gc
  gitCommit: 4ce5a8954017644c5420bae81d72b09b735c21f0
  gitTreeState: clean
  gitVersion: v1.24.0
  goVersion: go1.18.1
  major: "1"
  minor: "24"
  platform: darwin/arm64
kustomizeVersion: v4.5.4
serverVersion:
  buildDate: "2022-01-25T21:19:12Z"
  compiler: gc
  gitCommit: 816c97ab8cff8a1c72eccca1026f7820e93e0d25
  gitTreeState: clean
  gitVersion: v1.23.3
  goVersion: go1.17.6
  major: "1"
  minor: "23"
  platform: linux/arm64
```

# Install Minikube in MacOS M1
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-arm64
sudo install minikube-darwin-arm64 /usr/local/bin/minikube
```

Start Minikube, for this case I'll used docker as a virtualization
```bash
minikube start --driver=docker --alsologtostderr -v=1
```

Check whether minikube up and running
```bash
docker ps

#or 

minikube status
```

Running Minikube Dashboard
```bash
minikube dashboard
```

# Using Imperative Approach
## First Deployment

Build image of your application
```bash
cd kub-action-01-starting-setup
docker build -t kub-first-app .
```

Push image to docker hub
```bash
docker tag kub-first-app zulfikar4568/kub-first-app
docker push zulfikar4568/kub-first-app
```

```bash
kubectl help
kubectl create -h
# Using below command, deployment will successfully created, but since the image in our localhost, and kubernetes cluster is separate environment with our system, so will can't find the image, instead kubernetes will pull from docker registery (hub).

# kubectl create deployment first-app --image=kub-first-app
# kubectl delete deployment first-app

kubectl create deployment first-app --image=zulfikar4568/kub-first-app
kubectl get deployments
kubectl get pods
```

## 'Service' Object

Exposes Pods to Cluster or Externally. Pods have Internal IP address, but there's have two problem: 
  1. We can't access the IP from outside cluster. 
  2. Finding Pods is hard if IP changes all the times when pods is replace
Service group Pods with a Shared IP, this Shared IP will not change, and we can leverage this IP address and expose this shared IP.
Finally we can access Pods from external.

Type can use several help:
 1. ClusterIP
 2. NodePort
 3. LoadBalancer
   
```bash
kubectl expose deployment first-app --type=LoadBalancer --port=8080
minikube tunnel
kubectl get services first-app
#or
minikube service first-app
```
and access `http://<External IP>:8080`

## Restarting Container

Try access `http://<External IP>:8080/error`, this app will crash but kubernetes will doing automatically restart, and number of RESTARTS will increase
```bash
kubectl get pods
```

## Scalling in Action

Replica is simply an instance of a pod / Container. 3 Replicas means same pod / container will running 3 times
```bash
kubectl scale deployment/first-app --replicas=3
kubectl get pods
```

Set back to 1 scale
```bash
kubectl scale deployment/first-app --replicas=1
```

## Updating Deployments

For example you might be change your source code and want to update, you can implement this way.

First we try this way, the deployment will not effect since kubernetes want have different tag when have an update of image.
```bash
docker build -t zulfikar4568/kub-first-app .
docker push zulfikar4568/kub-first-app
kubectl set image deployment/first-app kub-first-app=zulfikar4568/kub-first-app
kubectl get deployments
```

Instead we can use this
```bash
docker build -t zulfikar4568/kub-first-app:2 .
docker push zulfikar4568/kub-first-app:2
kubectl set image deployment/first-app kub-first-app=zulfikar4568/kub-first-app:2
kubectl rollout status deployment/first-app
kubectl get deployments
```

## Deployment Rollback and History
 
 If we have use case when there's false tagging of our image. Our pods will not **goes down**, this is very nice, you can check on pods in minikube dashboard
 ```bash
kubectl set image deployment/first-app kub-first-app=zulfikar4568/kub-first-app:3
kubectl rollout status deployment/first-app
kubectl get pods
 ```

 Then we can implement rollout rollbacks
 ```bash
kubectl rollout undo deployment/first-app
 ```

 Look at to the history
 ```bash
kubectl rollout history deployment/first-app
#for the details
kubectl rollout history deployment/first-app --revision=3
 ```

 Then if we want to back to original deployment
 ```bash
kubectl rollout undo deployment/first-app --to-revision=1
kubectl rollout history deployment/first-app
 ```

 ## Delete Service and Deployment

 ```bash
kubectl delete service first-app
kubectl delete deployment first-app
 ```