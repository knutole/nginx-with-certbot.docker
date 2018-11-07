# nginx with certbot


## Usage

`docker-compose.yml:`
```yml
version: "3"
services:

  nginx: 
    build: https://github.com/knutole/nginx-with-certbot.docker.git
    environment:
        - NGINX_SERVER_NAME=my.server.com
        - NGINX_UPSTREAM=my-docker-service
    volumes:
      - ./ssl/:/home/ssl/
    ports:
      - "80:80"
      - "443:443"

```