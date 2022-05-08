Visit my repository [docker-laravel](https://github.com/zulfikar4568/docker-laravel)

Make sure you have:
* docker
* docker-compose </br>
If you doesn't have please install first in [Official Docker](https://docs.docker.com/engine/).
```
docker --version
docker-compose --version
```
You should be get like this, if have
```
Docker version 20.10.12, build e91ed57
docker-compose version 1.29.2, build 5becea4c
```

Clone this repository using this in your folder
```
git clone https://github.com/zulfikar4568/docker-laravel.git
```
## Creating Laravel Application via Utility Composer

```bash
docker-compose run --rm composer create-project --prefer-dist laravel/laravel .
```
After we execute above command we will see the our Laravel files in `src` folder

## Run the Laravel Application

You need setup the Laravel config, open and edit `src/.env`

```config
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=homestead
DB_USERNAME=homestead
DB_PASSWORD=secret
```

> Using this command when we will an updated the images
```bash
docker-compose up -d --build server
```
> Otherwise we can use this command, that will not updated a images
```bash
docker-compose up -d server
```
Open `localhost:8000`. Congratulations you've get the Laravel up and running wihout install dependencies in your host instead in our docker files.
## Error when running Laravel Application (Optional)
If you get an error like this `
The stream or file "/var/www/html/storage/logs/laravel.log" could not be opened in append mode: Failed to open stream: Permission denied`. This problem facing with your permission. Try using this command:
```
sudo chmod -R 777 ./src
```

## Doing Migration via Utility Artisan
Make sure container up & running, and type this command:
```
docker-compose run --rm artisan migrate
```

## Deploying Laravel Application

```
git checkout production
docker-compose up -d --build server
```