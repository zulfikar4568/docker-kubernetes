# Repairing Failed Pods in Kubernetes
As a Kubernetes Administrator, you will come across broken pods. Being able to identify the issue and quickly fix the pods is essential to maintaining uptime for your applications running in Kubernetes. In this hands-on lab, you will be presented with a number of broken pods. You must identify the problem and take the quickest route to resolve the problem in order to get your cluster back up and running.

Objective:
- Identify the broken pods.
- Find out why the pods are broken.
- Repair the broken pods.
- Ensure pod health by accessing the pod directly.

## Identify the broken pods.
1. Use the following command to see what’s in the cluster:
```bash
kubectl get all --all-namespaces
```
2. To make this a little easier to read, you could run the following command to view services, pods, and deployments:
```bash
kubectl get svc,po,deploy -n web
```
## Find out why the pods are broken.
1. Use the following command to inspect one of the broken pods and view the events, substituting the name of the pod for POD_NAME:
```bash
kubectl describe pod POD_NAME -n web
```
## Repair the broken pods.
1. Use the following command to repair the broken pods in the most efficient manner:
```bash
kubectl edit deploy nginx -n web
```
2. Where it says image: nginx:191, change it to image: nginx. Save and exit.

3. Verify the repair is complete:
```bash
kubectl get po -n web
```
4. See the new replica set:
```bash
kubectl get rs -n web
```
## Ensure pod health by accessing the pod directly.
1. List the pods including the IP addresses:
```bash
kubectl get po -n web -o wide
```
2. Start a busybox pod:
```bash
kubectl run busybox --image=busybox --rm -it --restart=Never -- sh
```
3. Use the following command to access the pod directly via its container port, replacing POD_IP_ADDRESS with an appropriate pod IP:
```bash
wget -qO- POD_IP_ADDRESS:80
```