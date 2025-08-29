#!/bin/sh

set -e

extra_hosts_file="/etc/hosts"
me=$(basename "$0")

cmd_log() {
    if [ -z "${NGINX_CMD_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

filters=$(jq -nc --arg compose_project_name "${COMPOSE_PROJECT_NAME}" \
    '{"label": ["com.docker.compose.project=" + $compose_project_name]}' | jq -sRr @uri)

containers=$(curl -s --unix-socket /var/run/docker.sock \
    "http://localhost/containers/json?filters=$filters")

echo -e "\n" >>"$extra_hosts_file"

echo "$containers" |
    jq -r '.[] | .Labels["com.docker.compose.service"] + " " + .NetworkSettings.Networks[].IPAddress' |
    while read -r line; do
        service_name=$(echo "$line" | awk '{print $1}')
        ip=$(echo "$line" | awk '{print $2}')

        if [ -n "$ip" ] && [ -n "$service_name" ]; then
            cmd_log "${me}: info: Adding \"$ip $service_name\" to $extra_hosts_file"
            echo "$ip $service_name" >>"$extra_hosts_file"
        fi
    done
