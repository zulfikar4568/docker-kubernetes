# Issue Permission
[Issue Permission in Node](https://github.com/nodejs/docker-node/issues/740)<br>
In Dockerfile Backend we specify `FROM node`, this will get an error if we want to read certain file inside their, so istead we must change path to `FROM node:14-alpine`, this is might be issue in the **latest version**

# Bringing Up images, container, volume, network, etc.
```bash
docker-compose up

#or

docker-compose up -d
```
# Bringing Down images, container, volume, network, etc.
```bash
docker-compose down

#or 

docker-compose down -v
```

# Docker Compose rebuild
If we running `docker-compose up` this will re-used image, not creating new images, for rebuild images we must add `--build`
```bash
docker-compose up --help
docker-compose up --build

# or this if you want to just build images
docker-compose build
```