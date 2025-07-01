#!/bin/sh

set -e

#npm install

if [ "$APP_ENV" = "local" ]; then
    #vite.sh
    #npm run dev
    tail -f /dev/null
else
    #npm run build

    export IS_READY=true

    while [ "$(docker inspect -f '{{.State.Health.Status}}' ${APP_NAME}-nginx 2>/dev/null)" != "healthy" ]; do
        sleep 1
    done

    docker rm -f "$(hostname)"
fi
