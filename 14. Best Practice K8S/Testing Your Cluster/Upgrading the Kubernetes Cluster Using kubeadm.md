# Upgrading the Kubernetes Cluster Using kubeadm
![image](https://github.com/zulfikar4568/docker-kubernetes/assets/64786139/f27605cc-921e-46cb-a219-27d09c7d6800)

we must perform the upgrade to all of the cluster components, including kube-controller-manager, kube-scheduler, kubeadm, and kubectl.

Objective:
- Install Version 1.18.5 of kubeadm on Master Node
- Upgrade Control Plane Components using kubeadm
- Install Version 1.18.5 of kubelet on Master Node
- Install Version 1.18.5 of kubectl on Master Node
- Install Version 1.18.5 of kubelet on The Worker Nodes

## Install Version 1.18.5 of kubeadm
1. On the master node, check the current version of kubeadm, then check for the Client Version and Server Version:
```bash
[master ]$ kubectl get nodes
[master ]$ kubectl version --short
```
2. Take the hold off of kubeadm and kubelet:
```bash
[master ]$ sudo apt-mark unhold kubeadm kubelet
```
3. Install them using the package manager:
```bash
[master ]$ sudo apt install -y kubeadm=1.18.5-00
```
4. Check the version again (which should show v1.18.5):
```bash
[master ]$ kubeadm version
```
5. Plan the upgrade to check for errors:
```bash
[master ]$ sudo kubeadm upgrade plan
```
6. Apply the upgrade of the kube-scheduler and kube-controller-manager:
```bash
[master ]$ sudo kubeadm upgrade apply v1.18.5
```
Enter y at the prompt.

7. Look at what version our nodes are at:
```bash
[master ]$ kubectl get nodes
```
## Install the Latest Version of kubelet on the Master Node
1. Make sure the kubelet package isn't on hold:
```bash
[master ]$ sudo apt-mark unhold kubelet
```
2. Install the latest version of kubelet:
```bash
[master ]$ sudo apt install -y kubelet=1.18.5-00
```
3. Verify that the installation was successful:
```bash
[master ]$ kubectl get nodes
```
This should show that the master node is on v1.18.5, but the two worker nodes are still at v1.17.8. If we run kubectl version --short again, we'll see that the Server Version is v1.18.5, and the Client Version is at v1.17.8.

## Install the Latest Version of kubectl on the Master Node
1. Make sure the kubectl package isn't on hold:
```bash
[master ]$ sudo apt-mark unhold kubectl
```
2. Install the latest version of kubectl:
```bash
[master ]$ sudo apt install -y kubectl=1.18.5-00
```
3. Verify that the installation was successful:
```bash
[master ]$ kubectl version --short
```
## Install the Newer Version of kubelet on the Worker Nodes
### On Worker 1
1. Make sure the kubelet package isn't on hold:
```bash
[worker1 ]$ sudo apt-mark unhold kubelet
```
2. Install the latest version of kubelet:
```bash
[worker1 ]$ sudo apt install -y kubelet=1.18.5-00
```
### On Worker 0
1. Make sure the kubelet package isn't on hold:
```bash
[worker0 ]$ sudo apt-mark unhold kubelet
```
2. Install the latest version of kubelet:
```bash
[worker0 ]$ sudo apt install -y kubelet=1.18.5-00
```
