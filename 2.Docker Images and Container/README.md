## Create & Running a container
```bash
docker run node

docker ps -a

docker run -it node

```

## Remove images and Container
```bash
docker stop <ID_Container>

docker rm <ID_Container1> <ID_Container2> <ID_Container3>

docker ps -a

docker images

docker rmi <ID_Image1> <ID_Image2> <ID_Image3>
```

## Remove unused images
```bash
docker image prune
```

## Automatically remove container
```bash
docker run -p 3000:80 -d --rm <ID_Image>
```

## Inspect image
```bash
docker image inspect <ID_Image>
```

## Copy file from local to docker
```bash
docker cp <source> <Container_name>:<target>
docker cp dummy/. <Container_name>:/test
```

## Copy file from docker to local
```bash
docker cp <Container_name>:<source> <target>
docker cp <Container_name>:/test dummy
```

## Naming and Taging
Create image with name:tag
```bash
docker build -t image_zul:latest .
```
Noted if you want to remove all images include tag use
```
docker image prune -a
```
### Running Container with name
```bash
docker run -p 3000:80 -d --rm --name container_zul image_zul:latest
```

## Push to Docker Registery
Login your docker
```bash
docker logout
docker login
```
Created image first or clone image
```bash
docker build -t zulfikar4568/my-aplikasi
or
docker tag node-demo:latest zulfikar4568/my-aplikasi
```
Pushing Image
```bash
docker push zulfikar4568/my-aplikasi
```

## Pulling Image
If the image in Public Repository, you can pull it without login
```bash
docker pull zulfikar4568/my-aplikasi
```