# nginx with certbot


## Usage

`docker-compose.yml:`
```yml
version: "3"
services:

    nginx: 
        build: https://github.com/knutole/nginx-with-certbot.docker.git
        environment:
            - NGINX_SERVER_NAME=my.server.com   # your web url
            - NGINX_UPSTREAM=my-upstream:8080   # docker-compose service
            - CERTBOT_EMAIL=email@server.com    # email for certbot
        volumes:
            - ./ssl/:/home/ssl/                 # folder to save ssl certificates across restarts
        ports:
            - "80:80"
            - "443:443"

    my-upstream:
        image: my-upstream-service-image


```