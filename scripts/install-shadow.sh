#!/bin/sh

set -e

if command -v apt-get >/dev/null; then
    # Debian/Ubuntu-based distributions
    apt-get update && apt-get install -y shadow-utils || echo "apt-get failed."

elif command -v yum >/dev/null; then
    # RHEL/CentOS-based distributions
    yum install -y shadow-utils || echo "yum failed."

elif command -v dnf >/dev/null; then
    # Fedora-based distributions
    dnf install -y shadow-utils || echo "dnf failed."

elif command -v microdnf >/dev/null; then
    # Minimal RHEL/Fedora-based distributions
    microdnf install -y shadow-utils || echo "microdnf failed."

elif command -v apk >/dev/null; then
    # Alpine-based distributions
    apk update && apk add --no-cache shadow || echo "apk failed."

elif command -v pacman >/dev/null; then
    # Arch Linux-based distributions
    pacman -Syu --noconfirm shadow || echo "pacman failed."

elif command -v zypper >/dev/null; then
    # SUSE-based distributions
    zypper install -y shadow || echo "zypper failed."

elif command -v emerge >/dev/null; then
    # Gentoo-based distributions
    emerge shadow || echo "emerge failed."

elif command -v slackpkg >/dev/null; then
    # Slackware-based distributions
    slackpkg install shadow || echo "slackpkg failed."

else
    echo "Package manager not found."
fi
