#!/bin/sh

set -e

exec tini -- composer "$@"
