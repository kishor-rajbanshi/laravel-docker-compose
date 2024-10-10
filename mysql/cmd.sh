#!/bin/sh

set -e

mysqld &

/tmp/ready-signal.sh

wait
