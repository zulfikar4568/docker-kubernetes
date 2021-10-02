## build image based on Dockerfile
Noted: Images `is Read Only`
```bash
docker build .
docker run <ID_Image>
docker stop <name_container>
```
## Running with PORT
You can access through http://localhost:3000/

I just want to clarify again, that EXPOSE `80` in the Dockerfile in the end is `optional`. It `documents` that a process in the container will expose this port. But you still need to then actually expose the port with -p when running docker run. So technically, -p is the `only required part` when it comes to listening on a port. Still, it is a `best practice` to also add EXPOSE in the Dockerfile to document this behavior.

### -p LOCALPORT:CONTAINERPORT
```bash
docker run -p 3000:80 <ID_Image>
```
### -d is Detach mode, by default is attached mode
```bash
docker run -p 3000:80 -d <ID_Image>
```
## If you want to back in attached mode
```bash
docker attach <name_container>

docker logs -f <name_container>
```