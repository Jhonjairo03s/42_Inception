FROM alpine:3.23

RUN <<EOF
apk update
apk add --no-cache nginx openssl
mkdir -p /etc/nginx/ssl
EOF

# https://wiki.alpinelinux.org/wiki/Nginx
COPY conf/nginx.conf /etc/nginx/

COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 443

ENTRYPOINT ["sh"]
CMD ["/usr/local/bin/entrypoint.sh"]
