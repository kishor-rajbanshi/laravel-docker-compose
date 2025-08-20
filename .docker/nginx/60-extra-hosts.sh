#!/bin/sh

set -e

me=$(basename "$0")

cmd_log() {
    if [ -z "${NGINX_CMD_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

filters=$(jq -nc --arg compose_project_name "$COMPOSE_PROJECT_NAME" \
    '{"label": ["com.docker.compose.project=" + $compose_project_name]}' | jq -sRr @uri)

containers=$(curl -s --unix-socket /var/run/docker.sock \
    "http://localhost/containers/json?filters=$filters")

echo -e "\n" >>/etc/hosts

echo "$containers" |
    jq -r '.[] | .Labels["com.docker.compose.service"] + " " + .NetworkSettings.Networks[].IPAddress' |
    while read -r line; do
        service_name=$(echo "$line" | awk '{print $1}')
        ip=$(echo "$line" | awk '{print $2}')

        if [ -n "$ip" ] && [ -n "$service_name" ]; then
            cmd_log "$me: info: Adding \"$service_name $ip\" to /etc/hosts"
            echo "$ip $service_name" >>/etc/hosts
        fi
    done
