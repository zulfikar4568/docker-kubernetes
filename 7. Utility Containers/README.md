# Another way docker offer
```bash
docker run -it node npm init
```

# Building First Utility Container
```dockerfile
FROM node:14-alpine

WORKDIR /app
```
We can create package.json and mount it to our host file system
```bash
# To build an image
docker build -t node-util .

#To Initialize project npm
docker run -it -v "$(pwd)"/app node-util npm init
```

# Utilizing ENTRYPOINT
```dockerfile
FROM node:14-alpine

WORKDIR /app

CMD [ "npm" ]
```

```bash
# To build an image
docker build -t mynpm.

#To Initialize project npm
docker run -it -v "$(pwd)"/app mynpm init

# To install dependencies
docker run -it -v "$(pwd)"/app mynpm install express --save
```

# Using Docker-Compose

```yaml
version: "3.8"
services:
  npmku:
    build: ./
    stdin_open: true
    tty: true
    volumes:
      - ./:/app
```

```bash
#To Initialize project npm
docker-compose run --rm npmku init

# To install dependencies
docker-compose run --rm npmku install
```