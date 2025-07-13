#!/bin/sh

while [ "$(docker inspect -f '{{.State.Status}}' ${APP_NAME}-nginx 2>/dev/null)" != "running" ]; do
    sleep 1
done

docker rm -f "$(hostname)"
