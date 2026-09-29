FROM alpine:3.23

# https://hub.docker.com/_/redis
RUN <<EOF
apk update
apk add --no-cache redis
EOF

COPY conf/redis.conf /etc/redis/

EXPOSE 6379

ENTRYPOINT ["redis-server"]
CMD ["/etc/redis/redis.conf"]
