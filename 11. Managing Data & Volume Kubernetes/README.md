# Make Deployment and Make Service

`deployment.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: story-deployment
spec:
  selector:
    matchLabels:
      app: story
  replicas: 1
  template:
    metadata:
      labels:
        app: story
    spec:
      containers:
        - name: story
          image: zulfikar4568/kub-data-demo
```

`service.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  name: story-service
spec:
  selector:
    app: story
  type: LoadBalancer
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
```

Apply to kubernetes
```bash
docker build -t zulfikar4568/kub-data-demo .
docker push zulfikar4568/kub-data-demo
kubectl apply -f=deployment.yaml,service.yaml
minikube tunnel
```

### Test our application
Open the Postman, Make a POST request `localhost/story`
```json
{
    "text": "This is new Text"
}
```

Get the request `localhost/story`

# 'emptyDir' Volume
There's many type of kubernetes volume, you can check in official [Kubernetes Volumes](https://kubernetes.io/docs/concepts/storage/volumes/). </br>
Make a use case when the app error, add another route in app.js
```js
app.get('/error', () => {
  process.exit(1);
});
```

Build new Image
```bash
docker build -t zulfikar4568/kub-data-demo:2 .
docker push zulfikar4568/kub-data-demo:2
````

Change in the deployment.yaml
```yaml
....
    spec:
      containers:
        - name: story
          image: zulfikar4568/kub-data-demo:2
```
Apply changes
```bash
kubectl apply -f=deployment.yaml,service.yaml
```

### Test our application
Open the Postman, Make a POST request `localhost/story`
```json
{
    "text": "This is new Text"
}
```

Get the request `localhost/story`, and the response is
```json
{
    "story": "This is new Text\n"
}
```

But if we access GET `localhost/error`, and GET back `localhost/story`, the response is
```json
{
    "story": ""
}
```

This is the case when our container crash and restart, our data will be **lost**.

Add emptyDir Volume in deployment.yaml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: story-deployment
spec:
  selector:
    matchLabels:
      app: story
  replicas: 1
  template:
    metadata:
      labels:
        app: story
    spec:
      containers:
        - name: story
          image: zulfikar4568/kub-data-demo:2
          volumeMounts:
            - mountPath: /app/story
              name: story-volume
      volumes:
        - name: story-volume
          emptyDir: {}
```

Apply changes
```bash
kubectl apply -f=deployment.yaml,service.yaml
```

### Test our application
Open the Postman, Make a POST request `localhost/story`
```json
{
    "text": "This is new Text"
}
```

Get the request `localhost/story`, and the response is
```json
{
    "story": "This is new Text\n"
}
```

But if we access GET `localhost/error`, and GET back `localhost/story`, the response is
```json
{
    "story": "This is new Text\n"
}
```

That mean is that now our application will not lost the data when container being restarted.

# 'hostPath' Volume

`emptDir` is very simple volume, the problem appears when we have multiple replicas, because emptyDir is only for 1 pods, solution for this we can use `hostPath`.
`hostPath` will shared the volume to multiple pods

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: story-deployment
spec:
  selector:
    matchLabels:
      app: story
  replicas: 3
  template:
    metadata:
      labels:
        app: story
    spec:
      containers:
        - name: story
          image: zulfikar4568/kub-data-demo:2
          volumeMounts:
            - mountPath: /app/story
              name: story-volume
      volumes:
        - name: story-volume
          hostPath:
            path: /data
            type: DirectoryOrCreate
```

`hostPath` also have a disadvantage, now we only working in 1 node. If we have multiple node it won't work, becase multiple pods and multiple replicas running on different node will not have an access to same data. If we have already existing data in our host directory, we can leverage this `hostPath`.

# From Volumes to Persistent Volumes
Volumes are destroyed when a Pod is removed. 
- [Block Storage vs. File Storage](https://www.youtube.com/watch?v=5EqAXnNm0FE). 
- [File (NAS) vs. Block (SAN) vs. Object Cloud Storage](https://www.youtube.com/watch?v=3r9RGJ0_Bls)

accessModes:
- ReadWriteOnce = Read and Write by single Node, pod can be different but must in the same node
- ReadOnlyMany = Read Only but can read by multiple node, so multiple pod on different node can claim same persistent volume
- ReadWriteMany = Read and Write but can read by multiple node, so multiple pod on different node can claim same persistent volume

Create Persistent Volume thus make file `host-pv.yaml`
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: host-pv
spec:
  capacity:
    storage: 1Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  storageClassName: standard
  hostPath:
    path: /data
    type: DirectoryOrCreate
```
Apply to Kubernetes
```bash
kubectl apply -f=host-pv.yaml
kubectl get pv
```

Create Persistent Volume Claim thus make file `host-pvc.yaml`
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: host-pvc
spec:
  volumeName: host-pv
  accessModes:
    - ReadWriteOnce
  storageClassName: standard
  resources:
    requests:
      storage: 1Gi
```

Apply to Kubernetes
```bash
kubectl apply -f=host-pvc.yaml
kubectl get pvc
```

Applying Claim in our Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: story-deployment
spec:
  selector:
    matchLabels:
      app: story
  replicas: 3
  template:
    metadata:
      labels:
        app: story
    spec:
      containers:
        - name: story
          image: zulfikar4568/kub-data-demo:
          volumeMounts:
            - mountPath: /app/story
              name: story-volume
      volumes:
        - name: story-volume
          persistentVolumeClaim:
            claimName: host-pvc
```

Apply to Kubernetes
```bash
kubectl apply -f=deployment.yaml
```

# Using Environment Variable

If we want set the `story` folder using env, we can use also in Kubernetes as below. Change our code
```js
const filePath = path.join(__dirname, process.env.STORY_FOLDER, 'text.txt');
```
Build Image
```bash
docker build -t zulfikar4568/kub-data-demo:3 .
docker push zulfikar4568/kub-data-demo:3
```

Edit our deployment file
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: story-deployment
spec:
  selector:
    matchLabels:
      app: story
  replicas: 3
  template:
    metadata:
      labels:
        app: story
    spec:
      containers:
        - name: story
          image: zulfikar4568/kub-data-demo:3
          env:
            - name: STORY_FOLDER
              value: 'story'
          volumeMounts:
            - mountPath: /app/story
              name: story-volume
      volumes:
        - name: story-volume
          persistentVolumeClaim:
            claimName: host-pvc
```

Apply to Kubernetes
```bash
kubectl apply -f=deployment.yaml
```

# Environment File and configMaps

When we want to use env for another pod we can implement this. Create file called `environment.yaml`
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: data-store-env
data:
  folder: 'story'
  # key1: value1
  # key2: value2
  # .....
```
Edit our deployment file
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: story-deployment
spec:
  selector:
    matchLabels:
      app: story
  replicas: 3
  template:
    metadata:
      labels:
        app: story
    spec:
      containers:
        - name: story
          image: zulfikar4568/kub-data-demo:3
          env:
            - name: STORY_FOLDER
              valueFrom:
                configMapKeyRef:
                  name: data-store-env
                  key: folder
          volumeMounts:
            - mountPath: /app/story
              name: story-volume
      volumes:
        - name: story-volume
          persistentVolumeClaim:
            claimName: host-pvc
```

Apply to Kubernetes
```bash
kubectl apply -f=environment.yaml
kubectl get configmap
kubectl describe configmap data-store-env
kubectl apply -f=deployment.yaml
```