#!/bin/sh

set -e

if [ "${ENV}" = "development" ]; then
    if command -v nginx-debug >/dev/null; then
        /docker-entrypoint.sh nginx-debug -g 'daemon off;'
    fi
else
    /docker-entrypoint.sh nginx -g 'daemon off;'
fi

/tmp/ready-signal.sh
