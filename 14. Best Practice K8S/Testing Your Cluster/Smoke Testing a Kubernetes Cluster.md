# Smoke Testing a Kubernetes Cluster

we'll go through the process of performing basic smoke tests on several Kubernetes features, with the goal of verifying the overall health of the cluster. The features we'll test here are ones that are particularly prone to failure when something is wrong with the cluster.

Your team has just finished setting up a new Kubernetes cluster. But before moving your company’s online store to the cluster, they want to make sure the cluster is set up correctly. The team has asked you to run a series of smoke tests against the cluster in order to make sure everything is working.

You can complete most of the steps for this activity on the controller server, so get logged in to the controller. You will only need to log in to one of the workers for part of the Verify that untrusted workloads run using gVisor task.

## Verify the Cluster's Ability to Perform Data Encryption
Create some sensitive data and verify it is stored in an encrypted format.

1. Create some test data that will be encrypted:
```bash
kubectl create secret generic kubernetes-the-hard-way --from-literal="mykey=mydata"
```
2. Get the raw data from etcd:
```bash
sudo ETCDCTL_API=3 etcdctl get \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/etcd/ca.pem \
  --cert=/etc/etcd/kubernetes.pem \
  --key=/etc/etcd/kubernetes-key.pem\
  /registry/secrets/default/kubernetes-the-hard-way | hexdump -C
```
3. Your output should look something like this:
```bash
00000000  2f 72 65 67 69 73 74 72  79 2f 73 65 63 72 65 74  |/registry/secret|
00000010  73 2f 64 65 66 61 75 6c  74 2f 6b 75 62 65 72 6e  |s/default/kubern|
00000020  65 74 65 73 2d 74 68 65  2d 68 61 72 64 2d 77 61  |etes-the-hard-wa|
00000030  79 0a 6b 38 73 3a 65 6e  63 3a 61 65 73 63 62 63  |y.k8s:enc:aescbc|
00000040  3a 76 31 3a 6b 65 79 31  3a fc 21 ee dc e5 84 8a  |:v1:key1:.!.....|
00000050  53 8e fd a9 72 a8 75 25  65 30 55 0e 72 43 1f 20  |S...r.u%e0U.rC. |
00000060  9f 07 15 4f 69 8a 79 a4  70 62 e9 ab f9 14 93 2e  |...Oi.y.pb......|
00000070  e5 59 3f ab a7 b2 d8 d6  05 84 84 aa c3 6f 8d 5c  |.Y?..........o.\|
00000080  09 7a 2f 82 81 b5 d5 ec  ba c7 23 34 46 d9 43 02  |.z/.......#4F.C.|
00000090  88 93 57 26 66 da 4e 8e  5c 24 44 6e 3e ec 9c 8e  |..W&f.N.\$Dn>...|
000000a0  83 ff 40 9a fb 94 07 3c  08 52 0e 77 50 81 c9 d0  |..@....<.R.wP...|
000000b0  b7 30 68 ba b1 b3 26 eb  b1 9f 3f f1 d7 76 86 09  |.0h...&...?..v..|
000000c0  d8 14 02 12 09 30 b0 60  b2 ad dc bb cf f5 77 e0  |.....0.`......w.|
000000d0  4f 0b 1f 74 79 c1 e7 20  1d 32 b2 68 01 19 93 fc  |O..ty.. .2.h....|
000000e0  f5 c8 8b 0b 16 7b 4f c2  6a 0a                    |.....{O.j.|
000000ea
```
4. Look for k8s:enc:aescbc:v1:key1 on the right of the output to verify the data is stored in an encrypted format.

## Verify that Deployments Work
1. Create a new deployment:
```bash
kubectl run nginx --image=nginx
```
2. Verify the deployment created a pod and that the pod is running:
```bash
kubectl get pods -l run=nginx
```
3. Verify the output looks something like this:
```bash
NAME                     READY     STATUS    RESTARTS   AGE
nginx-65899c769f-9xnqm   1/1       Running   0          30s
```
4. The pod should be in the Running STATUS with 1/1 containers READY.

## Verify Remote Access Works via Port Forwarding
1. First, get the pod name of the nginx pod and store it as an environment variable:
```bash
POD_NAME=$(kubectl get pods -l run=nginx -o jsonpath="{.items[0].metadata.name}")
```
2. Forward port 8081 to the nginx pod:
```bash
kubectl port-forward $POD_NAME 8081:80
```
3. Open up a new terminal, log in to the controller server, and verify the port forward works:
```bash
curl --head http://127.0.0.1:8081
```
4. You should get an http 200 OK response from the nginx pod.

When you are done, you can stop the port-forward in the original terminal with CTRL+C.

## Verify You Can Access Container Logs with kubectl Logs
1. Go back to the first terminal to run this test. If you are in a new terminal, you may need to set the <POD_NAME> environment variable again:
```bash
POD_NAME=$(kubectl get pods -l run=nginx -o jsonpath="{.items[0].metadata.name}")
```
2. Get the logs from the nginx pod:
```bash
kubectl logs $POD_NAME
```
3. This command should return the nginx pod's logs. It will look something like this (but there could be more lines):
```bash
127.0.0.1 - - [10/Sep/2018:19:29:01 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.47.0" "-"
```

## Verify You Can Execute Commands Inside a Container with kubectl exec
1. Execute a simple nginx -v command inside the nginx pod:
```bash
kubectl exec -ti $POD_NAME -- nginx -v
```
2. This command should return the Nginx version output, which should look like this:
```bash
nginx version: nginx/1.15.3
```

## Verify Services Work
1. Create a service to expose the nginx deployment:
```bash
kubectl expose deployment nginx --port 80 --type NodePort
```
2. Get the node port assigned to the newly created service and assign it to an environment variable:
```bash
NODE_PORT=$(kubectl get svc nginx --output=jsonpath='{range .spec.ports[0]}{.nodePort}')
```
3. Access the service on one of the worker nodes from the controller like this (10.0.1.102 is the private IP of one of the workers):
```bash
curl -I 10.0.1.102:$NODE_PORT
```
4. You should get an http 200 OK response.