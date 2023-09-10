FROM alpine:latest

RUN apk add --no-cache hugo git nginx openssh

WORKDIR /app

EXPOSE 8080/tcp

CMD git clone "$REPO" ./ && /bin/sh -c './watch.sh' && hugo && nginx -g 'daemon off;'
