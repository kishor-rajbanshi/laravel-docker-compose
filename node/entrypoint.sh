#!/bin/sh

if [ $# -gt 0 ]; then
    npm $@
else
    npm install

    if [ "$ENV" = "development" ]; then
        npm run dev &
    else
        npm run build
    fi

    /tmp/ready-signal.sh

    tail -f /dev/null
fi
