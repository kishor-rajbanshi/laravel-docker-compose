#!/bin/sh

set -e

entrypoint_log() {
    if [ -z "${INSTALL_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

url="https://github.com/kishor-rajbanshi/laravel-docker-compose.git"

if [ ! -d "/app" ]; then
    entrypoint_log "$0: Error: Required volume not mounted. Aborting."
    exit 1
fi

if [ -d "/app/.docker" ] && [ "$(ls -A /app/.docker 2>/dev/null || true)" ]; then
    entrypoint_log "$0: Error: target .docker exists and is not empty. Aborting."
    exit 1
fi

if [ -f "/app/compose.yml" ] || [ -f "/app/docker-compose.yml" ]; then
    entrypoint_log "$0: Error: compose.yml or docker-compose.yml already exists. Aborting."
    exit 1
fi

[ -z "$BRANCH" ] && BRANCH="main"

url="$(echo "$url" | sed -E 's#\.git$##')/archive/refs/heads/$BRANCH.zip"

wget -q -O "/tmp/laravel-docker-compose.zip" "$url"

if [ $? -ne 0 ]; then
    entrypoint_log "$0: Error: Failed to download archive from $url"
    exit 1
fi

unzip -q "/tmp/laravel-docker-compose.zip" -d "/tmp"

trap 'rm -rf /app/.docker' ERR
mkdir -p "/app/.docker" || {
    entrypoint_log "$0: Error: Could not create .docker directory."
    false
    exit 1
}

cp -r /tmp/laravel-docker-compose-$BRANCH/.docker/* /app/.docker/ || {
    entrypoint_log "$0: Error: Failed to copy files to .docker"
    false
    exit 1
}

trap 'rm -rf /app/compose.yml' ERR
cp /tmp/laravel-docker-compose-$BRANCH/compose.yml /app/compose.yml || {
    entrypoint_log "$0: Error: Failed to copy compose.yml"
    false
    exit 1
}

merge_env_files() {
    local src="$1"
    local dest="$2"

    [ ! -f "$dest" ] && trap 'rm -rf "$dest"' ERR && cp "$src" "$dest" && return 0

    [ "$(tail -n1 "$dest")" != "" ] && echo "" >>"$dest"

    while IFS= read -r line || [ -n "$line" ]; do

        if [ -z "$line" ]; then
            if ! tail -n1 "$dest" | grep -q '^$'; then
                echo "" >>"$dest"
            fi
            continue
        fi

        local key="${line%%=*}"

        if ! grep -Eq "^$key=" "$dest"; then
            echo "$line" >>"$dest"
        fi
    done <"$src"

    sed -i 's/^# DB_HOST=.*/# DB_HOST=db/' "$dest"
    sed -i 's/^DB_HOST=.*/DB_HOST=db/' "$dest"

    if grep -q '^DB_CONNECTION=sqlite' "$dest"; then
        sed -i 's/^DB_DATABASE=laravel/# DB_DATABASE=laravel/' "$dest"
    fi

}

merge_env_files "/tmp/laravel-docker-compose-$BRANCH/.env.example" "/app/.env.example"
merge_env_files "/tmp/laravel-docker-compose-$BRANCH/.env.example" "/app/.env"

echo "Installation complete"
