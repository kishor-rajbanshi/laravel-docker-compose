#!/bin/sh

set -e

server_map="/ssl/server.map"

unique_name() {
    dir="$1"
    length="$2"
    while :; do
        rand=$(head -c 512 /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c "$length")
        [ ! -e "$dir/$rand" ] && echo "$rand" && return
    done
}

while IFS= read -r line; do
    first_domain=$(printf "%s" "$line" | awk -F'=>' '{split($1,a," "); print a[1]}')

    domains=$(echo "$line" | awk -F'=>' '{print $1}' | xargs -n1 | sed 's/^/-d "/; s/$/"/' | tr '\n' ' ')

    webroot=$(echo "$line" | awk -F'=>' '{print $2}' | xargs)

    cert_home=/acme/$(unique_name "/acme/" 12)
    cert_name=/ssl/$(unique_name "/ssl/" 8).pem
    cert_key_name=/ssl/$(unique_name "/ssl/" 8).pem

    echo $cert_home
    echo $cert_name
    echo $cert_key_name

    acme.sh \
        --cert-home $cert_home \
        --issue $domains \
        -w "$webroot" \
        --renew-hook 'id=$(curl -s --unix-socket /var/run/docker.sock \
            -H "Content-Type: application/json" \
            -X POST "http://localhost/containers/${COMPOSE_PROJECT_NAME}-nginx/exec" \
            -d "{\"AttachStdout\":true,\"AttachStderr\":true,\"Cmd\":[\"nginx\",\"-s\",\"reload\"]}" \
            | sed -n "s/.*\"Id\":\"\([^\"]*\)\".*/\1/p"); \
            curl -s --unix-socket /var/run/docker.sock \
            -H "Content-Type: application/json" \
            -X POST "http://localhost/exec/$id/start" \
            -d "{\"Detach\":false,\"Tty\":false}"'

    acme.sh \
        --cert-home $cert_home \
        --install-cert -d "$first_domain" \
        --key-file $ert_key_name \
        --fullchain-file $cert_name
done < $server_map

[ -f "$server_map" ] && rm -rf "$server_map"

/entry.sh daemon
