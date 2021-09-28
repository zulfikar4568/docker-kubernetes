# 1.1 node-app - Create Dockerfile and build image
```dockerfile
FROM node

WORKDIR /node-app

COPY package.json /node-app

RUN npm install

COPY . /node-app

CMD ["node", "server.js"]
```
```bash
docker image build .
```
# 1.2 python-app - Create Dockerfile and build image
```dockerfile
FROM python

WORKDIR /python-app

COPY . /python-app

CMD ["python", "bmi.py"]
```
```bash
docker image build .
```
# 2.1 Running node-app

```bash
docker images

docker run -p 3000:3000 -d 0ed3db963b1e
```
# 2.2 Running python-app
```bash
docker images

docker run -it 430c763689d0
```
# 3 Re-created container with name
```bash
docker run -p 3000:3000 -d --name node-app 0ed3db963b1e
docker run -it --name python-app 430c763689d0
```

# 4.1 clean up images and container node-app

```bash
docker ps
docker stop 662c01fc4ad2
docker rm 662c01fc4ad2

docker images
docker rmi 0ed3db963b1e
```

# 4.2 Clean up image and container python-app
```bash
docker ps -a
docker rm d0673b9af84c
docker images
docker rmi 430c763689d0
```

# 5 Re-build image with name and tag
```bash
docker image build -t node-app:1.0.0 .
docker image build -t python-app:1.0.0 .
```
# 6 Run container based on rebuilt images
```bash
docker run -p 3000:3000 -d --rm --name container-node node-app:1.0.0
docker stop container-node
docker run -it --rm --name container-python python-app:1.0.0
```
## Clean all stopped containers
```bash
docker image prune -a
```