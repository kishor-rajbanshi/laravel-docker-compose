#!/bin/sh

set -e

if [ "$SSL_ENABLED" = "false" ]; then
    curl --unix-socket /var/run/docker.sock -X DELETE http://localhost/containers/$(hostname)?force=true
fi

/entry.sh daemon