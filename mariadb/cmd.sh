#!/bin/sh

set -e

/usr/local/bin/docker-entrypoint.sh mariadbd &

/tmp/ready-signal.sh

wait
