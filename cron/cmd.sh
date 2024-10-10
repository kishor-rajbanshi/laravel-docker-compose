#!/bin/sh

crond -f -l 8 -L /var/log/cron.log &

/tmp/ready-signal.sh

wait
