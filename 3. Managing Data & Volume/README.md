# Anonymous Volume (Managed by docker)
> We can created through `dockerfile` or in `docker run`
```bash
docker build -t feedback-node . 

docker run -p 3000:80 -d  --name feedback-app --rm -v app/feedback feedback-node

# check volume
docker volume ls
# You should see

: ' DRIVER    VOLUME NAME
local     3bd77c6b7ae10f181d49b8fd64adf5f7993cc0ce15e5b6a2c5e72dadb330635b '

docker stop feedback-app

dokcer volume ls
# If container is removed and then volume would be gone
```

# Using docker Named Volumes (Managed by Docker)
```bash
docker build -t feedback-node .

docker run -p 3000:80 -d  --name feedback-app --rm -v feedback:/app/feedback feedback-node

docker volume ls

# We should get this, feedback volume has been created!
: ' DRIVER    VOLUME NAME
local     feedback '


docker stop feedback-app

docker volume ls

# We still see this, even container has been removed!
: ' DRIVER    VOLUME NAME
local     feedback '

# to deleted unused anonymous volumes
docker volume rm <Vol_Name>
# or
docker volume prune

```

# Using Bind Mounts (Managed by you)

> - macOS / Linux: `-v $(pwd):/app` <br>
> - Windows: `-v "%cd%":/app`

```bash
docker run -p 3000:80 -d  --name feedback-app --rm -v --env PORT:3000 feedback:/app/feedback -v "/home/zulfikar/Docker/UDEMY/3. Managing Data & Volume/app":/app -v /app/node_modules feedback-node 

# or

docker run -p 3000:80 -d  --name feedback-app --rm -v --env PORT:3000 feedback:/app/feedback -v "$(pwd)":/app -v /app/node_modules feedback-node 
```

# Using Bind Mounts with Nodemon in node js
> Comment `CMD [ "node", "server.js" ]` in `Dockerfile `
```bash
docker run -p 3000:80 -d  --name feedback-app --rm -v --env PORT:3000 feedback:/app/feedback -v "$(pwd)":/app -v /app/node_modules feedback-node 
```

# Read Only Volumes 
```bash
docker run -p 3000:80 -d  --name feedback-app --rm -v --env PORT:3000 feedback:/app/feedback -v "$(pwd)":/app:ro -v /app/temp -v /app/node_modules feedback-node
```

# Managed Docker Volumes
> Create docker volumes manually, but actually docker will automatically managed volume, except the Bind Mounts
```bash
docker volume --help

docker volume create feedback-files

docker run -p 3000:80 -d  --name feedback-app --rm --env PORT:3000 -v feedback-files:/app/feedback -v "$(pwd)":/app:ro -v /app/temp -v /app/node_modules feedback-node
```
> Remove docker volumes
```bash
docker volume inspect feedback-list
docker volume rm feedback-list
docker volume prune
```

# Using .ENV
```bash
docker run -p 3000:80 -d  --name feedback-app --rm --env PORT:3000 -v feedback-files:/app/feedback -v "$(pwd)":/app:ro -v /app/temp -v /app/node_modules feedback-node

#or 

docker run -p 3000:80 -d  --name feedback-app --rm --env-file ./.env -v feedback-files:/app/feedback -v "$(pwd)":/app:ro -v /app/temp -v /app/node_modules feedback-node
```

# Using ARG
```dockerfile
FROM node:14

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

ARG DEFAULT_PORT=80

ENV PORT $DEFAULT_PORT

EXPOSE $PORT

CMD [ "node", "server.js" ]
# CMD [ "npm", "start" ]
```
```bash
docker build -t feedback-node:dev --build-arg DEFAULT_PORT=3000 .
```