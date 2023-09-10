FROM alpine:latest

RUN apk add --no-cache hugo git

WORKDIR /app

EXPOSE 1313/tcp

ENTRYPOINT (git clone "$REPO" . || git fetch && git reset --hard origin) && git submodule update --init --remote && hugo serve --baseURL "$BASE_URL" -p "$PORT" --bind '0.0.0.0' -e "$HUGO_ENV" --disableFastRender --disableLiveReload 
