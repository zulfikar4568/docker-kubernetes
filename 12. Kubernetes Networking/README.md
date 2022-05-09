# Creating Deployment for our application users

First we want to dummy user application, hence we update the `users-app.js`
```js
// const hashedPW = await axios.get('http://auth/hashed-password/' + password);
const hashedPW = 'dummy text';
```

and

```js
// const response = await axios.get(
//   'http://auth/token/' + hashedPassword + '/' + password
// );
const response = {status:200, data: {token: 'abc'}};
```

Build Image
```bash
docker build -t zulfikar4568/kub-demo-users .
docker push zulfikar4568/kub-demo-users
```

Make `users-deployment.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: users-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: users
  template:
    metadata:
      labels:
        app: users
    spec:
      containers:
        - name: users
          image: zulfikar4568/kub-demo-users
```

Make `users-services.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  name: users-service
spec:
  selector:
    app: users
  type: LoadBalancer
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8080
```

Apply to Kubernetes
```bash
kubectl apply -f=users-deployment.yaml
kubectl get deployments
kubectl apply -f=users-service.yaml
kubectl get services
```

```bash
curl -X POST http://localhost:8080/login -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"email": "test@gmail.com", "password": "testers"}'

curl -X POST http://localhost:8080/signup -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"email": "test@gmail.com", "password": "testers"}'
```

# Connect Users app to Auth App (Pod-Internal Communication)
Edit `docker-compose.yaml`
```yaml
version: "3"
services:
  auth:
    build: ./auth-api
  users:
    build: ./users-api
    environment:
      AUTH_ADDRESS: auth
    ports: 
      - "8080:8080"
  tasks:
    build: ./tasks-api
    ports: 
      - "8000:8000"
    environment:
      TASKS_FOLDER: tasks
    
```
First we need to deploy auth app first
```
docker build -t zulfikar4568/kub-demo-auth .
docker push zulfikar4568/kub-demo-auth
```

We need to change the url in order to connect with auth, hence we update the `users-app.js`
```js
const hashedPW = await axios.get(`http://${process.env.AUTH_ADDRESS}/hashed-password/` + password);
```

and

```js
const response = await axios.get(
  `http://${process.env.AUTH_ADDRESS}/token/` + hashedPassword + '/' + password
);
```

Rebuild Users Image
```bash
docker build -t zulfikar4568/kub-demo-users .
docker push zulfikar4568/kub-demo-users
```

Auth app is expose in port 80, but we wan't this auth app expose to the outside world instead of in internal node, and we will create users and auth in the same pod, so we will use in same file `users-deployment.yaml` in order to deploy `auth-app`

Edit `users-deployment.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: users-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: users
  template:
    metadata:
      labels:
        app: users
    spec:
      containers:
        - name: users
          image: zulfikar4568/kub-demo-users:latest
          env:
            - name: AUTH_ADDRESS
              value: localhost
        - name: auth
          image: zulfikar4568/kub-demo-auth:latest
```

Apply to Kubernetes
```bash
kubectl apply -f=users-deployment.yaml
kubectl get pods
```

```bash
curl -X POST http://localhost:8080/login -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"email": "test@gmail.com", "password": "testers"}'

curl -X POST http://localhost:8080/signup -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"email": "test@gmail.com", "password": "testers"}'
```


# Pod to Pod Communication

Previously we deploy users and auth app in single pod together, but there's problem when we have Task app for example that need to talk with Auth app, hence we need to make users and auth in separate pods so Task app can reach Auth app.

## Using IP Address
Since we don't want expose auth app to outside world, instead we need to change auth using `ClusterIP` instead `LoadBalancer`, don't worry that `ClusterIP` have mechanism `LoadBalancer` as well.

We create `auth.deployment.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: auth-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: auth
  template:
    metadata:
      labels:
        app: auth
    spec:
      containers:
        - name: auth
          image: zulfikar4568/kub-demo-auth:latest
```

We create `auth.service.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  name: auth-service
spec:
  selector:
    app: auth
  type: ClusterIP
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

Apply to Kubernetes
```bash
kubectl apply -f=auth-deployment.yaml,auth-service.yaml
kubectl get services
```

We will have an ClusterIP of `auth_service`, we can get the IP, and implement to `user_service`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: users-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: users
  template:
    metadata:
      labels:
        app: users
    spec:
      containers:
        - name: users
          image: zulfikar4568/kub-demo-users:latest
          env:
            - name: AUTH_ADDRESS
              value: "10.99.166.199"
```

Apply to Kubernetes
```bash
kubectl apply -f=users-deployment.yaml
```

```bash
curl -X POST http://localhost:8080/login -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"email": "test@gmail.com", "password": "testers"}'

curl -X POST http://localhost:8080/signup -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"email": "test@gmail.com", "password": "testers"}'
```

The application should be still working, but to getting the ClusterIP a bit anoying, and thus we can try using environment variable

## Using Environment Variable

This host of environment variable will auth generate by kubernetes, for example our service name is
`auth_service` then will generate environment variable `AUTH_SERVICE_SERVICE_HOST`.

We need to chhange the url in order to connect with auth, hence we update the `users-app.js`
```js
const hashedPW = await axios.get(`http://${process.env.AUTH_SERVICE_SERVICE_HOST}/hashed-password/` + password);
```

and

```js
const response = await axios.get(
  `http://${process.env.AUTH_SERVICE_SERVICE_HOST}/token/` + hashedPassword + '/' + password
);
```
also `docker-compose.yaml`, in order docker-compose can running as well

```yaml
version: "3"
services:
  auth:
    build: ./auth-api
  users:
    build: ./users-api
    environment:
      AUTH_SERVICE_SERVICE_HOST: auth
    ports: 
      - "8080:8080"
  tasks:
    build: ./tasks-api
    ports: 
      - "8000:8000"
    environment:
      TASKS_FOLDER: tasks
```

Rebuild Users Image
```bash
docker build -t zulfikar4568/kub-demo-users .
docker push zulfikar4568/kub-demo-users
kubectl delete deployment users-deployment
kubectl apply -f=users-deployment.yaml
```

```bash
curl -X POST http://localhost:8080/login -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"email": "test@gmail.com", "password": "testers"}'

curl -X POST http://localhost:8080/signup -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"email": "test@gmail.com", "password": "testers"}'
```

## Using DNS

By default Kubernetes have CoreDNS, so we can use DNS instead IP or Environment Variable. The format is `<service_name>.<namespace>` for example `auth_service.default`.

Update `users.deployment.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: users-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: users
  template:
    metadata:
      labels:
        app: users
    spec:
      containers:
        - name: users
          image: zulfikar4568/kub-demo-users:latest
          env:
            - name: AUTH_ADDRESS
              value: "auth-service.default"
```

Change back users application to AUTH_ADDRESS, and Build, and Apply users.deployment.yaml to Kubernetes.

## Implement Task app

Change the code `tasks-app.js`
```js
const response = await axios.get(`http://${process.env.AUTH_ADDRESS}/verify-token/` + token);
```

Create `tasks-deployment.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tasks-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: tasks
  template:
    metadata:
      labels:
        app: tasks
    spec:
      containers:
        - name: tasks
          image: zulfikar4568/kub-demo-tasks:latest
          env:
            - name: AUTH_ADDRESS
              value: "auth-service.default"
            - name: TASKS_FOLDER
              value: tasks
```

Create `tasks-service.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  name: tasks-service
spec:
  selector:
    app: tasks
  type: LoadBalancer
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8080
```

Build Users Image
```bash
docker build -t zulfikar4568/kub-demo-tasks .
docker push zulfikar4568/kub-demo-tasks
kubectl apply -f=tasks-deployment.yaml,tasks-service.yaml
```

```bash
curl -X GET http://localhost:8000/tasks -H 'Authorization: Bearer abc'

curl -X POST http://localhost:8000/tasks -H 'Authorization: Bearer abc' -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"text": "Task pertama", "title": "Lakukan task ini"}'
```