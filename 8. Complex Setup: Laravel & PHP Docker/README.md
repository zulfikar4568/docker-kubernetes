# Adding Nginx Container
```yaml
version: "3.8"
services:
  server:
    image: 'nginx:stable-alpine'
    ports:
      - '8080:80'
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
```

# Adding PHP Container
```dockerfile
FROM php:7.4-fpm-alpine

WORKDIR /var/www/html

RUN docker-php-ext-install pdo pdo_mysql
```

```yaml
  php:
    build:
      context: ./dockerfiles
      dockerfile: php.dockerfile
    volumes:
      - ./src:/var/www/html:delegated
```

# Adding MYSQL
```yaml
  mysql:
    image: mysql:5.7
    env_file:
      - ./env/mysql.env
```
```conf
MYSQL_DATABASE=homestead
MYSQL_USER=homestead
MYSQL_PASSWORD=secret
MYSQL_ROOT_PASSWORD=secret
```

# Adding Composer
```yaml
  composer:
    build:
      context: ./dockerfiles
      dockerfile: composer.dockerfile
    volumes:
      - ./src:/var/www/html
```

```dockerfile
FROM composer:latest

WORKDIR /var/www/html

ENTRYPOINT [ "composer", "--ignore-platform-reqs" ]
```

# Creating Laravel via Container utility docker
```bash
docker-compose run --rm composer create-project --prefer-dist laravel/laravel .
```

# Fixing Error (Optional if you got an error)
When using Docker on Linux, you might face permission errors when adding a bind mount as shown in the next lecture.
change `php.dockerfile` like this
```dockerfile
FROM php:7.4-fpm-alpine
 
WORKDIR /var/www/html
 
COPY src .
 
RUN docker-php-ext-install pdo pdo_mysql
 
RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel
 
USER laravel
```
change composer.dockerfile like this
```dockerfile
FROM composer:latest
 
RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel
 
USER laravel
 
WORKDIR /var/www/html
 
ENTRYPOINT [ "composer", "--ignore-platform-reqs" ]
```

```bash
docker-compose run --rm composer create-project --prefer-dist laravel/laravel .

docker-compose up -d --build
```