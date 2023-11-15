# Creating Persistent Storage for Pods in Kubernetes
![image](https://github.com/zulfikar4568/docker-kubernetes/assets/64786139/62ee2211-eacd-4b0f-886c-df5ca7b4a8ca)

Pods in Kubernetes are ephemeral, which makes the local container filesytem unusable, as you can never ensure the pod will remain. To decouple your storage from your pods, you will be creating a persistent volume to mount for use by your pods. You will be deploying a redis image. You will first create the persistent volume, then create the pod YAML for deploying the pod to mount the volume. You will then delete the pod and create a new pod, which will access that same volume.

To decouple our storage from our pods, we will create a persistent volume to mount for use by our pods. We will deploy a redis image. We will first create the persistent volume, then create the pod YAML for deploying the pod to mount the volume. We will then delete the pod and create a new pod, which will access that same volume.

Objective:
- Create a PersistentVolume.
- Create a PersistentVolumeClaim.
- Create the redispod image, with a mounted volume to mount path `/data`
- Connect to the container and write some data.
- Delete `redispod` and create a new pod named `redispod2`.
- Verify the volume has persistent data.

## Create a PersistentVolume.
1. Create the file, named redis-pv.yaml:
```bash
vim redis-pv.yaml
```
2. Use the following YAML spec for the PersistentVolume:
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: redis-pv
spec:
  storageClassName: manual
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data"    
```

3. Then, create the PersistentVolume:
```bash
kubectl apply -f redis-pv.yaml
```

## Create a PersistentVolumeClaim.
1. Create the file, named redis-pvc.yaml:
```bash
vim redis-pvc.yaml
```
2. Use the following YAML spec for the PersistentVolumeClaim:
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: redisdb-pvc
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```
3. Then, create the PersistentVolumeClaim:
```bash
kubectl apply -f redis-pvc.yaml
```

## Create a pod from the redispod image, with a mounted volume to mount path **/data**.
1. Create the file, named redispod.yaml:
```bash
vim redispod.yaml
```
2. Use the following YAML spec for the pod:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: redispod
spec:
  containers:
  - image: redis
    name: redisdb
    volumeMounts:
    - name: redis-data
      mountPath: /data
    ports:
    - containerPort: 6379
      protocol: TCP
  volumes:
  - name: redis-data
    persistentVolumeClaim:
      claimName: redisdb-pvc
```
3. Then, create the pod:
```bash
kubectl apply -f redispod.yaml
```
4. Verify the pod was created:
```bash
kubectl get pods
```

## Connect to the container and write some data.
1. Connect to the container and run the redis-cli:
```bash
kubectl exec -it redispod redis-cli
```
2. Set the key space server:name and value "redis server":
```bash
SET server:name "redis server"
```
3. Run the GET command to verify the value was set:
```bash
GET server:name
```
4. Exit the redis-cli:
```bash
QUIT
```

## Delete redispod and create a new pod named redispod2.
1. Delete the existing redispod:
```bash
kubectl delete pod redispod
```
2. Open the file **redispod.yaml** and change line 4 from name: redispod to:
```bash
name: redispod2
```
3. Create a new pod named redispod2:
```bash
kubectl apply -f redispod.yaml
```

## Verify the volume has persistent data.
1. Connect to the container and run redis-cli:
```bash
kubectl exec -it redispod2 redis-cli
```
2. Run the GET command to retrieve the data written previously:
```bash
GET server:name
```
3. Exit the redis-cli:
```bash
QUIT
````
