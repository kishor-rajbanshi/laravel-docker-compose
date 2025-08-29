#!/bin/sh

set -e

cmd_log() {
    if [ -z "${DB_CMD_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

while true; do
  status="$(curl -s --unix-socket /var/run/docker.sock http://localhost/containers/${COMPOSE_PROJECT_NAME}-nginx/json | jq -r '.State.Status' 2>/dev/null)"

  [ "$status" = "running" ] && break

  cmd_log "${0}: info: Waiting for ${COMPOSE_PROJECT_NAME}-nginx to start"
  
  sleep 1
done

curl -s -X DELETE --unix-socket /var/run/docker.sock "http://localhost/containers/$(hostname)?force=true"
