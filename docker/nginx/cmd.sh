#!/bin/sh

set -e

if [ "${APP_ENV}" = "local" ] && command -v nginx-debug >/dev/null; then
    /docker-entrypoint.sh nginx-debug -g 'daemon off;'
else
    /docker-entrypoint.sh nginx -g 'daemon off;'
fi