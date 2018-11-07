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
            - NGINX_UPSTREAM=my-upstream:8080
        volumes:
            - ./ssl/:/home/ssl/
        ports:
            - "80:80"
            - "443:443"

    my-upstream:
        image: my-sandboxed-server


```