#!/bin/sh

if [ $# -gt 0 ]; then
    composer $@
else
    if [ "$ENV" = "development" ]; then
        composer install
    else
        composer install --no-dev --optimize-autoloader
    fi

    /tmp/ready-signal.sh

    tail -f /dev/null
fi
