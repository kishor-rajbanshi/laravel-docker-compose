#!/bin/sh

if supervisorctl status | awk '{print $2}' | grep -vq RUNNING; then
  echo "❌ One or more programs are not running"
  exit 1
fi

echo "✅ All programs are running"
exit 0
