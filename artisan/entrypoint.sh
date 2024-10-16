#!/bin/sh

if [ $# -gt 0 ]; then
    php artisan $@
else

    php artisan down

    if [ "$ENV" = "development" ]; then
        php artisan optimize:clear
        php artisan migrate --force
        php artisan db:seed
    else
        php artisan optimize
        php artisan migrate --force
    fi

    php artisan up

    /tmp/ready-signal.sh

    tail -f /dev/null
fi
