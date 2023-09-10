#!/bin/sh

while true; do
  git fetch && git reset --hard origin
  sleep 60
done

