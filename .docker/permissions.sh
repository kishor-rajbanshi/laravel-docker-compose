#!/bin/sh

set -e

apk update && apk add --no-cache shadow

usermod -u "$USER_ID" "$1"
groupmod -g "$GROUP_ID" "$1"

find / -path /proc -prune -o -user "$USER_ID" -exec chown -h "$1" {} +
find / -path /proc -prune -o -group "$GROUP_ID" -exec chgrp -h "$1" {} +
