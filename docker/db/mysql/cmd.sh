#!/bin/sh

set -e

ln -sf /var/db /var/lib

docker-entrypoint.sh mysqld
