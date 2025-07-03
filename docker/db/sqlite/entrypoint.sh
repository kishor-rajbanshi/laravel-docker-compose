#!/bin/sh

while [ "$(docker inspect -f '{{.State.Health.Status}}' ${APP_NAME}-nginx 2>/dev/null)" != "healthy" ]; do
  sleep 1
done

docker rm -f "$(hostname)"
