FROM alpine:3.23

RUN <<EOF
apk update
apk add --no-cache php85 php85-fpm php85-mysqli php85-phar php85-mbstring curl
EOF

# https://www.wp-cli.es/instalar/
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN php wp-cli.phar --info
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

COPY conf/www.conf /etc/php85/php-fpm.d/

COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["sh"]
CMD ["/usr/local/bin/entrypoint.sh"]
