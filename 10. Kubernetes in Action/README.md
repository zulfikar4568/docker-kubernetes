![components-of-kubernetes](./components-of-kubernetes.svg)

# Install Kubectl

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
minikube start --driver=docker --alsologtostderr
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