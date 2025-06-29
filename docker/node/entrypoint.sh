#!/bin/sh

if [ $# -gt 0 ]; then
    $@
else
    npm install

    if [ "$APP_ENV" = "local" ]; then
        vite.sh
        npm run dev
    else
        npm run build

        while [ "$(docker inspect -f '{{.State.Health.Status}}' ${APP_NAME}-nginx 2>/dev/null)" != "healthy" ]; do
            sleep 1
        done

        docker rm -f "$(hostname)"
    fi
fi