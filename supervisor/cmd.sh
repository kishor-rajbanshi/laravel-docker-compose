#!/bin/sh

set -e

supervisord -c /etc/supervisor/supervisord.conf &

/tmp/ready-signal.sh

wait
