# Connect our container to our local machine
If we have mongodb installed in our machine, Change code to this:
```javascript
mongoose.connect(
  'mongodb://host.docker.internal:27017/swfavorites',
  { useNewUrlParser: true },
  (err) => {
    if (err) {
      console.log(err);
    } else {
      app.listen(3000);
    }
  }
);
```
Running our container
```bash
docker build -t favorites-node .

docker run -d --rm -p 3000:3000 --name favorites-app fovorites-node
```

# Container to Container connection
Running mongo container 
```bash
docker run -d --name mongodb mongo
```
Find out IP of mongo db
```bash
docker container inspect mongodb
```
Change the code to this
```javascript
mongoose.connect(
  'mongodb://172.17.0.2:27017/swfavorites',
  { useNewUrlParser: true },
  (err) => {
    if (err) {
      console.log(err);
    } else {
      app.listen(3000);
    }
  }
);
```
# Container network
```bash
docker network create favorites-net

docker network create --driver bridge favorites-net

docker network ls
```
```javascript
mongoose.connect(
  'mongodb://mongodb:27017/swfavorites',
  { useNewUrlParser: true },
  (err) => {
    if (err) {
      console.log(err);
    } else {
      app.listen(3000);
    }
  }
);
```
We don't need `-p 3000:3000` because we use for communication only in local
```bash
docker run -d --name mongodb --network favorites-net mongo

docker run -d --rm --name favorites-app --network favorites-net fovorites-node
```

# Docker Network Drivers
Docker Networks actually support different kinds of **"Drivers"** which influence the behavior of the Network.

The default driver is the **"bridge"** driver - it provides the behavior shown in this module (i.e. Containers can find each other by name if they are in the same Network).

The driver can be set when a Network is created, simply by adding the `--driver` option.
```bash
docker network create --driver bridge my-net
```
Of course, if you want to use the "bridge" driver, you can simply omit the entire option since "bridge" is the default anyways.

Docker also supports these alternative drivers - though you will use the "bridge" driver in most cases:

1. **host**: For standalone containers, isolation between container and host system is removed (i.e. they share localhost as a network)

2. **overlay**: Multiple Docker daemons (i.e. Docker running on different machines) are able to connect with each other. Only works in "Swarm" mode which is a dated / almost deprecated way of connecting multiple containers

3. **macvlan**: You can set a custom MAC address to a container - this address can then be used for communication with that container

4. **none**: All networking is disabled.

5. **Third-party plugins**: You can install third-party plugins which then may add all kinds of behaviors and functionalities

As mentioned, the "bridge" driver makes most sense in the vast majority of scenarios.