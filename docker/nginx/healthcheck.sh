#!/bin/sh

set -e

if ! wget -q --spider http://localhost; then
    echo "❌ HTTP check failed: localhost is not reachable"
    exit 1
fi

echo "✅ HTTP check passed: localhost is reachable"
exit 0