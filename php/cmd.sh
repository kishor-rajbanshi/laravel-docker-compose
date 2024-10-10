#!/bin/sh

set -e

php-fpm &

/tmp/ready-signal.sh

wait
