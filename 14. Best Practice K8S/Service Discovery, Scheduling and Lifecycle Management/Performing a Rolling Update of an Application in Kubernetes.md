# Performing a Rolling Update of an Application in Kubernetes
you are provided with a 3-node cluster. Within that cluster, you must deploy an application and then successfully update the application to a new version without causing any downtime.

Objective:
- Create and Roll Out Version 1 of the Application, and Verify a Successful Deployment
- Scale Up the Application to Create High Availability
- Create a Service So Users Can Access the Application
- Perform a Rolling Update to Version 2 of the Application, and Verify Its Success

```bash
kubectl get nodes
```

## Create and Roll Out Version 1 of the Application, and Verify a Successful Deployment
1. Create and open the kubeserve-deployment.yaml to create your deployment:
```bash
vim kubeserve-deployment.yaml
```
2. Insert the following YAML into the file:

Note: When copying and pasting code into Vim from the lab guide, first enter :set paste (and then i to enter insert mode) to avoid adding unnecessary spaces and hashes. To save and quit the file, press Escape followed by :wq. To exit the file without saving, press Escape followed by :q!.
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kubeserve
spec:
  replicas: 3
  selector:
    matchLabels:
      app: kubeserve
  template:
    metadata:
      name: kubeserve
      labels:
        app: kubeserve
    spec:
      containers:
      - image: linuxacademycontent/kubeserve:v1
        name: app
```
3. Press Escape and type :wq! to save and quit the file.

4. Create the deployment:
```bash
kubectl apply -f kubeserve-deployment.yaml
```
5. Verify the deployment was successful:
```bash
kubectl rollout status deployments kubeserve
```
6. You should see that the deployment was successfully rolled out.

7. Verify the app is at the correct version:
```bash
kubectl describe deployment kubeserve
```
8. You should see that the image is version 1.

## Scale Up the Application to Create High Availability
1. Check for pods:
```bash
kubectl get pods
```
2. You should see 3 pods.

3. Scale up your application to 5 replicas:
```bash
kubectl scale deployment kubeserve --replicas=5
```
4. Verify the additional replicas have been created:
```bash
kubectl get pods
```
5. You should now see 5 pods.

## Create a Service So Users Can Access the Application
1. Create a service for your deployment:
```bash
kubectl expose deployment kubeserve --port 80 --target-port 80 --type NodePort
```
2. Verify the service is present:
```bash
kubectl get services
```
3. Copy the Cluster-IP of the NodePort service from this screen. You will need it for the next objective.

## Perform a Rolling Update to Version 2 of the Application, and Verify Its Success
1. Start another terminal session logged in to the same Kube Master server. There, use the following curl loop command to see the version change as you perform the rolling update. Replace <ip-address-of-the-service> with the Cluster-IP of the NodePort service you copied before:
```bash
while true; do curl http://<ip-address-of-the-service>; done
```
2. Perform the update in the original terminal session (while the curl loop is running in the second terminal session):
```bash
kubectl set image deployments/kubeserve app=linuxacademycontent/kubeserve:v2 --v 6
```
After you run this command, if you view the second terminal session, you should see v2 of the pod displayed in the output. Press CTRL+C to stop.

3. In the first terminal, view the additional ReplicaSet created during the update:
```bash
kubectl get replicasets
```
You should see 2 replicasets.

4. Verify all pods are up and running:
```bash
kubectl get pods
```
You should still see 5 pod replicas.

5. View the rollout history:
```bash
kubectl rollout history deployment kubeserve
```
You should see 2 rollouts.
