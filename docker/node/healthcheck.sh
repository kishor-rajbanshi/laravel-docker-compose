#!/bin/sh

set -e

if [ "$APP_ENV" = "local" ]; then
    wget -q --spider http://localhost:5173 && exit 0 || exit 1
else
    [ "$IS_READY" = "true" ] && exit 0 || exit 1
fi
