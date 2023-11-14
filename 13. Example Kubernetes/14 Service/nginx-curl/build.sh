# Build image
docker build -t zulfikar4568/nginx-curl .

# Push image
docker push zulfikar4568/nginx-curl

# Create container
docker container create --name nginx-curl zulfikar4568/nginx-curl

# Start container
docker container start nginx-curl

# See container logs
docker container logs -f nginx-curl

# Stop container
docker container stop nginx-curl

# Remove container
docker container rm nginx-curl