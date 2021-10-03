# Build image simple app
This app does'nt have database, volume ,etc
```bash
docker build -t node-dep-example .

docker run --rm -d --name node-dep -p 80:80 node-dep-example
```

# Connect to AWS EC2, please use free tier for learning
Create EC2 AMI free tier, make user VPS is created by default and review and launch, before you launch download key.pem first <br>
Make sure instance has been running, and click the instance -> click connect -> Click Client SSH
> Download your key.pem, and change path where you store key.pem
```bash
chmod 400 example-1.pem

ssh -i "example-1.pem" ec2-user@ec2-54-151-179-201.ap-southeast-1.compute.amazonaws.com
```

# Install Docker in AWS EC2
Type on your instance AWS
```bash
sudo yum update -y
sudo amazon-linux-extras install docker
sudo service docker status
sudo service docker start
docker --version

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

# Publish your image to docker hub
Click create repository, for example `node-example-1`. Create `.dockerignore`
```
node_modules
Dockerfile
*.pem
```
Build image and push to registery
```bash
# Build image
docker build -t node-example-1 .

# Re-tagging your image
docker tag node-example-1 zulfikar4568/node-example-1
docker images

docker login
docker push zulfikar4568/node-example-1
```

# Running & Publishing the image to the AWS EC2
```bash
docker run -d --rm -p 80:80 zulfikar4568/node-example-1
```
and open your IP public of your instance, you might be will not get a response, this is about security group

scroll down in the instance dashboard, find the security grup and click. `Edit Inbound Rules` click `Add Rule`, select type to `HTTP`

and open your IP public of your instance in the browser

# Updating Image / Container on AWS EC2
> On local machine
```bash
# Re-build image
docker build -t node-example-1 .

# Re-tagging your image
docker tag node-example-1 zulfikar4568/node-example-1
docker images

docker push zulfikar4568/node-example-1
```
> On Remote MAchine
```bash
docker ps

docker stop infallible_hofstadter

docker pull zulfikar4568/node-example-1

docker run -d --rm -p 80:80 zulfikar4568/node-example-1
```
