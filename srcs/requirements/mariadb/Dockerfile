FROM alpine:3.23

RUN <<EOF
apk update
apk add --no-cache mariadb mariadb-client
EOF

# https://wiki.alpinelinux.org/wiki/MariaDB
COPY conf/* /etc/my.cnf.d/

COPY tools/* /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["sh"]
CMD ["/usr/local/bin/entrypoint.sh"]
