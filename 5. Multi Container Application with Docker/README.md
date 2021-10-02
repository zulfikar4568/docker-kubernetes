# Running MongoDB
> Expose mongodb to our localhost
```bash
docker run --name mongodb --rm -d -p 27017:27017 mongo
```

# Dockerizing Node App
Create docker file
```dockerfile
FROM node

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 80

CMD ["node","app.js"]
```
Build image
```bash
docker build -t goals-node .
```
Change javascript file connection mongo
```javascript
mongoose.connect(
  'mongodb://host.docker.internal:27017/course-goals',
  {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  },
  (err) => {
    if (err) {
      console.error('FAILED TO CONNECT TO MONGODB');
      console.error(err);
    } else {
      console.log('CONNECTED TO MONGODB');
      app.listen(80);
    }
  }
);
```
Run Container
```bash
docker run --name goals-backend --rm -d -p 80:80 goals-node
```

# Dockerizing React App
```dockerfile
FROM node

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .
 
EXPOSE 3000

CMD [ "npm", "start" ]
```
Build an image
```bash
docker build -t goals-react .
```
Running a Container
```bash
docker run --name goals-frontend --rm -d -p 3000:3000 -it goals-react 
```

# Adding Docker Network for efficient Cross Container Communication
```bash
docker network ls

docker network create goals-net
```
> Running mongodb through network
```bash
docker run --name mongodb --rm -d --network goals-net mongo
```
> **Running backend through network** <br>
Change javascript mongodb connection, since we are not expose port anymore, instead we are using network, so host we can name of the container `mongodb`
```javascript
mongoose.connect(
  'mongodb://mongodb:27017/course-goals',
  {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  },
  (err) => {
    if (err) {
      console.error('FAILED TO CONNECT TO MONGODB');
      console.error(err);
    } else {
      console.log('CONNECTED TO MONGODB');
      app.listen(80);
    }
  }
);
```
Build image
```bash
docker build -t goals-node .
```

We need still publish port `-p 80:80` since later react will not use network 
```bash
docker run --name goals-backend --rm -d -p 80:80 --network goals-net goals-node
```

> Running React App

Since we know react is frontend application which means that this application will running in the browser, so it's ok we can running this application without a network

Rebuild image
```bash
docker build -t goals-react .
```
Running a Container, and expose `-p 3000:3000` since react must be accessed from the browser
```bash
docker run --name goals-frontend --rm -p 3000:3000 -it goals-react 
```

# Adding Persistance data mongodb
Add **Named Volumes**, since docker have some kind of volume, **Anonymous volume, Named volume, Bind volume**
```bash
docker run --name mongodb --rm -d -v data:/data/db --network goals-net -e MONGO_INITDB_ROOT_USERNAME=max -e MONGO_INITDB_ROOT_PASSWORD=secret mongo
```

# Volume, Bind backend app

We need still publish port `-p 80:80` since later react will not use network, so backend must expose port 80

add nodemon in package.json
```javascript
{
  "name": "backend",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "start": "nodemon app.js"
  },
  "author": "zul",
  "license": "ISC",
  "dependencies": {
    "body-parser": "^1.19.0",
    "express": "^4.17.1",
    "mongoose": "^5.10.3",
    "morgan": "^1.10.0"
  },
  "devDependencies": {
    "nodemon": "^2.0.4"
  }
}
```

and change Dockerfile
```dockerfile
FROM node

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 80

ENV MONGODB_USERNAME=max
ENV MONGODB_PASSWORD=secret

CMD ["npm","start"]
```
Change javascript `app.js`
```javascript
mongoose.connect(
  `mongodb://${process.env.MONGODB_USERNAME}:${process.env.MONGODB_PASSWORD}@mongodb:27017/course-goals?authSource=admin`,
  {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  },
  (err) => {
    if (err) {
      console.error('FAILED TO CONNECT TO MONGODB');
      console.error(err);
    } else {
      console.log('CONNECTED TO MONGODB');
      app.listen(80);
    }
  }
);
```
Rebuild image and Running Container

```bash
docker build -t goals-node .

docker run --name goals-backend -v "$(pwd)":/app -v logs:/app/logs -v /app/node_modules -e MONGODB_USERNAME=max --rm -d -p 80:80 --network goals-net goals-node
```

# Volume, Bind Frontend app

```bash
docker build -t goals-react .

docker run --name goals-frontend -v "$(pwd)/src":/app/src --rm -p 3000:3000 -it goals-react 
```