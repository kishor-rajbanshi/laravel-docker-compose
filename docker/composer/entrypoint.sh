#!/bin/sh

if [ $# -gt 0 ]; then
    composer $@
else
    if [ "$APP_ENV" = "local" ]; then
        composer install
    else
        composer install --no-dev --optimize-autoloader
    fi

    touch /tmp/ready

    tail -f /dev/null
fi