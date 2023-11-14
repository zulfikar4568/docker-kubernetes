# Creating a ClusterRole to Access a PV in Kubernetes
you will be tasked with accessing a persistent volume from a pod in order to view the available volumes inside the Kubernetes cluster. By default, pods cannot access volumes directly, so you will also need to create a cluster role to provide authorization to the pod. Additionally, you cannot access the API server directly without authentication, so you will need to run kubectl in proxy mode to retrieve information about the volumes.

The first container, using the image **tutum/curl**, will allow you to use curl to directly access the Kubernetes REST API.

## View the Persistent Volume
1. View the Persistent Volume within the cluster:
```bash
kubectl get pv
```
## Create a ClusterRole
1. Create the ClusterRole:
```bash
kubectl create clusterrole pv-reader --verb=get,list --resource=persistentvolumes
```
2. Describe
```bash
kubectl describe clusterrole pv-reader
```
## Create a ClusterRoleBinding
1. Create the ClusterRoleBinding:
```bash
kubectl create clusterrolebinding pv-test --clusterrole=pv-reader --serviceaccount=web:default
```
2. Describe
```bash
kubectl describe clusterrolebinding pv-test
```
## Create a Pod to Access the PV
1. Create the curlpod.yaml file:
```bash
vim curlpod.yaml
```
1. Add the following YAML to create a pod that will proxy the connection and allow you to curl the address:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: curlpod
  namespace: web
spec:
  containers:
  - image: curlimages/curl
    command: ["sleep", "9999999"]
    name: main
  - image: linuxacademycontent/kubectl-proxy
    name: proxy
  restartPolicy: Always
```
1. Save and exit the file by pressing Escape followed by :wq.

2. Create the pod:
```bash
kubectl apply -f curlpod.yaml
```
## Request Access to the PV from the Pod
1. Open a new shell to the pod:
```bash
kubectl exec -it curlpod -n web -- sh
```
If it doesn't work immediately, wait a minute or so and then run the command again.

1. Curl the PV resource:
```bash
curl localhost:8001/api/v1/persistentvolumes
```