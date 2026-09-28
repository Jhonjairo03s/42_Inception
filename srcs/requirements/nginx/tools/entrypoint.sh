#!/bin/sh


if [ ! -f "/etc/nginx/ssl/certAutofirmado.crt" ]; 
then
	# https://nubelonia.com/crear-docker-nginx-con-alpine-autocertificado-ssl/
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout /etc/nginx/ssl/certAutofirmado.key \
		-out /etc/nginx/ssl/certAutofirmado.crt \
		-subj "/C=ES/ST=Pais Vasco/L=Urduliz/O=42/CN=$DOMAIN_NAME"
fi

# https://labex.io/questions/what-is-the-purpose-of-the-nginx-g-daemon-off-command-in--871954
exec /usr/sbin/nginx -g 'daemon off;'
