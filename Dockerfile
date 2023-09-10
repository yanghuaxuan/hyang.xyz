FROM alpine:latest

RUN apk add --no-cache hugo git nginx openssh

WORKDIR /app

COPY ./watch.sh /
COPY ./nginx-entrypoint.sh /

EXPOSE 8080/tcp

ENTRYPOINT git clone "$REPO" . && git submodule update --init && /bin/sh -c '/watch.sh &' ls && hugo && /nginx-entrypoint.sh && nginx -g 'daemon off;'
