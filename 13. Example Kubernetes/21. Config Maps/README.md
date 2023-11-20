## Create and Connect to a GKE Cluster
1. Using the main navigation menu, under COMPUTE, select Kubernetes Engine.
2. Click ENABLE.
3. Once enabled, click CREATE.
4. To the right of In the Standard: You manage your cluster, click CONFIGURE.
5. At the top, choose USE A SETUP GUIDE, and choose My first cluster.
6. Click CREATE NOW.
7. Once the cluster has been created, click the three vertical dots and choose Connect.
8. Under Command-line access, click Run in Cloud Shell.
9. When prompted, click Continue.
10. When the terminal has launched, hit Return to run the command.
11. When prompted, click Authorize.


## Build the Container and Create the Deployment
1. In the Cloud Shell terminal, clone the repo for this lab from GitHub:
```bash
git clone https://github.com/linuxacademy/content-google-certified-pro-cloud-developer
```
2. Change to the /flask-configmaps/ directory inside the cloned lab repo:
```bash
cd content-google-certified-pro-cloud-developer/flask-configmaps/
```
3. Use gcloud builds to create the container image, replacing <your-project-id> with the ID of your project:
```bash
gcloud builds submit --tag gcr.io/<your-project-id>/flask-configmaps
```
4. If prompted, enter y to enable the Cloud Build API.

5. Click the Open Editor button above the terminal to open the Cloud Shell Editor, and open the Editor in a new window.

6. In the File menu, click New File.

7. Name the file deployment.yaml and click OK.

8. In the new file, paste the following, replacing <your-project-id> with the ID of your project:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-deployment
spec:
  selector:
    matchLabels:
      app: flask
  template:
    metadata:
      labels:
        app: flask
    spec:
      containers:
      - name: flask
        image: gcr.io/<your-project-id>/flask-configmaps
        ports:
        - containerPort: 8080
```
9. In the File menu, click Save All.

10. Return to the Cloud Shell terminal tab and click Open Terminal.

11. Clear the screen and change back to the home directory:
```bash
clear
cd
```
12. Create the deployment using the deployment.yaml file:
```bash
kubectl apply -f deployment.yaml
```
13. Create a load balancer service and expose the deployment:
```bash
kubectl expose deployment flask-deployment --port=80 --target-port=8080 --type=LoadBalancer
```
14. After a few minutes, an external IP address should be provisioned for the service. View the service and external IP:
```bash
kubectl get services
```
15. Copy the external IP and paste it in a new browser tab to confirm the deployment is working.

## Use a ConfigMap to Add Environment Variables
1. Return to the Cloud Shell terminal.

2. Create a new ConfigMap called animal-config using the literal values dogs=10 and cats=5:
```bash
kubectl create configmap animal-config --from-literal=dogs=10 --from-literal=cats=5
```
3. Return to the tab with the Cloud Shell Editor.

4. Update the deployment.yaml file to create environment variables from this ConfigMap by adding the following under the container image, at the same indentation level. If you are using copy and paste, you may have to correct some indentation. Just make sure that env starts at the same indentation level as the image directive above it.
```yaml
env:
  - name: NUM_DOGS
    valueFrom:
      configMapKeyRef:
        name: animal-config
        key: dogs
  - name: NUM_CATS
    valueFrom:
      configMapKeyRef:
        name: animal-config
        key: cats
```
5. In the File menu, click Save.

6. Return to the Cloud Shell terminal tab and reapply the deployment:
```bash
kubectl apply -f deployment.yaml
```
7. Reload the web page where the external IP address was pasted. The app should now display the environment variables.

## Use a ConfigMap to Add a Configuration File
1. Return to the Cloud Shell Editor tab.

2. In the File menu, click New File.

3. Name the file animals.cfg and click OK.

4. In the file, paste in the following:
```bash
catfood=kibble
dogfood=mixer
fussy_dog=derek
latest_feed=10pm
```
5. In the File menu, click Save.

6. Return to the Cloud Shell terminal.

7. Create a new ConfigMap called animal-configfile using the file you just created:
```bash
kubectl create configmap animal-configfile --from-file=animals.cfg
```
8. Return to the Cloud Shell Editor tab.

9. Update the deployment.yaml file to create a volume from this ConfigMap and mount it into the Pod. Add the following under the container image, at the same indentation level. If you are using copy and paste, you may have to correct some indentation. Just make sure that volumeMounts starts at the same indentation level as the image directive above it.
```yaml
volumeMounts:
- name: animal-configfile-volume
  mountPath: /data
```
10. Add the volume to the end of the deployment.yaml file. The volumes directive should start at the same indentation level as the containers directive:
```yaml
volumes:
  - name: animal-configfile-volume
    configMap:
      name: animal-configfile
```
11. In the File menu, click Save.

12. Return to the Cloud Shell terminal and reapply the deployment:
```bash
kubectl apply -f deployment.yaml
```
13. Reload the web page where the external IP address was pasted. The app should now display the contents of the config file as well.