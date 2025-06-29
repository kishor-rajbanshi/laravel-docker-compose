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
    fi
fi