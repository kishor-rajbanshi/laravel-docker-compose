#!/bin/sh

set -e

if [ "$SSL_ENABLED" = "false" ]; then
    docker rm -f "$(hostname)"
fi

/entry.sh daemon