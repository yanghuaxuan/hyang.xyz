#!/bin/sh

while true; do
  (git fetch && git reset --hard origin) || git clone "$REPO" . && git submodule update --init
  git submodule update --remote
  hugo
  rm -Rf /var/www/hugo_pub
  mv -f ./public /var/www/hugo_pub
  chown -R root:www-data /var/www/hugo_pub
  sleep 60
done

