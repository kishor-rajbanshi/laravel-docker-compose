#!/bin/sh

set -e

server_map="/ssl/server.map"

while IFS= read -r line; do
    domains=$(echo "$line" | awk -F'=>' '{print $1}' | xargs -n1 | sed 's/^/-d /' | tr '\n' ' ')
    webroot=$(echo "$line" | awk -F'=>' '{print $2}' | xargs)
    acme.sh --issue $domains-w $webroot --renew-hook "docker exec nginx nginx -s reload"
done < $server_map

[ -f "$server_map" ] && rm -rf "$server_map"

/entry.sh daemon
