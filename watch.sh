#!/bin/sh

while true; do
  (git fetch && git reset --hard origin) || git clone "$REPO" . && git submodule update --init
  git submodule update --remote
  sleep 60
done

