#!/bin/sh

set -e

/usr/local/bin/docker-entrypoint.sh mysqld &

/tmp/ready-signal.sh

wait
