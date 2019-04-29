#!/bin/bash
set -e

echo "Starting identidock system"

docker run -d --restart=on-failure:5 --name redis redis
docker run -d --restart=on-failure:5 --name dnmonster amouat/dnmonster
docker run -d --restart=on-failure:5 \
  --link dnmonster:dnmonster \
  --link redis:redis \
  -e ENV=PROD \
  --name identidock msereda/identidock:newest
docker run -d --restart=on-failure:5 \
  --name proxy \
  --link identidock:identidock \
  -p 80:80 \
  -e NGINX_HOST=192.168.0.11 \
  -e NGINX_PROXY=http://identidock:9090 \
  msereda/proxy:newest

echo "Started"