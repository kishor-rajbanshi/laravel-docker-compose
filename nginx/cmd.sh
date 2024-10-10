#!/bin/sh

set -e

if [ "${ENV}" = "development" ]; then
    if command -v nginx-debug >/dev/null; then
        nginx-debug -g 'daemon off;'
    fi
else
    nginx -g 'daemon off;'
fi

/tmp/ready-signal.sh
