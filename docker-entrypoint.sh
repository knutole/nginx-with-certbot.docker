#!/bin/bash

NGINX_CONFIG=/etc/nginx/nginx.conf
NGINX_CERTBOT_CONFIG=/etc/nginx/nginx-certbot.conf

echo "ENV:"
echo "NGINX_SERVER_NAME: $NGINX_SERVER_NAME"
echo "NGINX_UPSTREAM: $NGINX_UPSTREAM"

create_certs () {

    # ensure dir
    mkdir -p /home/ssl

    # parse nginx certbot config
    parse_nginx_certbot_config
    
    # start nginx with certbot config
    nginx -c $NGINX_CERTBOT_CONFIG

    echo "Creating certificates..."

    # ensure certificate
    certbot certonly -a webroot --webroot-path=/var/www/html -d "$CERTBOT_DOMAIN" \
        --agree-tos \
        --email "$CERTBOT_EMAIL" \
        --hsts \
        --non-interactive

    # move certificates
    cp /etc/letsencrypt/live/$CERTBOT_DOMAIN/fullchain.pem /home/ssl/fullchain.pem
    cp /etc/letsencrypt/live/$CERTBOT_DOMAIN/privkey.pem /home/ssl/privkey.pem

    # stop
    service nginx stop
}

create_diffie () {
    openssl dhparam -out /home/ssl/dhparams.pem 2048
}

parse_nginx_certbot_config () {
    cp /etc/nginx/nginx-certbot.conf.default $NGINX_CERTBOT_CONFIG
    sed -i "/{SERVER_NAME}/c\\$NGINX_SERVER_NAME" $NGINX_CERTBOT_CONFIG
}

parse_nginx_config () {
    cp /etc/nginx/nginx.conf.default $NGINX_CONFIG
    sed -i "/{SERVER_NAME}/c\\$NGINX_SERVER_NAME" $NGINX_CONFIG
    sed -i "/{UPSTREAM}/c\\$NGINX_UPSTREAM" $NGINX_CONFIG
}


if [ ! -f "/home/ssl/fullchain.pem" ]; then
    create_certs
fi
if [ ! -f "/home/ssl/privkey.pem" ]; then
    create_certs
fi
if [ ! -f "/home/ssl/dhparams.pem" ]; then
    create_diffie
fi


# parse nginx config
parse_nginx_config

# start nginx
nginx -c $NGINX_CONFIG
