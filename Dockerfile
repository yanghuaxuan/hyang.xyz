FROM alpine:latest

RUN apk add --no-cache hugo git

COPY . /app

WORKDIR /app

RUN ./watch.sh &

EXPOSE 443/tcp

ENTRYPOINT /bin/sh -c './watch.sh' && hugo serve --baseURL "$BASE_URL" -p "$PORT" --bind '0.0.0.0' -e "$HUGO_ENV" --disableFastRender --disableLiveReload 
