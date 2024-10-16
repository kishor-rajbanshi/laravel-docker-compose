#!/bin/sh

set -e

/usr/local/bin/docker-php-entrypoint php-fpm &

/tmp/ready-signal.sh

wait
