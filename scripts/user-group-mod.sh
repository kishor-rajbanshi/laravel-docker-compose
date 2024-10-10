#!/bin/sh

set -e

usermod -u "$UID" "$1"
groupmod -g "$GID" "$1"

find / -path /proc -prune -o -user "$UID" -exec chown -h "$1" {} +
find / -path /proc -prune -o -group "$GID" -exec chgrp -h "$1" {} +
