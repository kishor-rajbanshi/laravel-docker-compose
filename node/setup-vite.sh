#!/bin/sh

CONFIG_FILE="/var/www/html/vite.config.js"

if grep -q "server:" "$CONFIG_FILE"; then
    if grep -q "host:" "$CONFIG_FILE"; then
        sed -i "s/host: '[^']*'/host: '0.0.0.0'/" "$CONFIG_FILE"
    else
        sed -i '/server:/a\        host: '\''0.0.0.0'\'',' "$CONFIG_FILE"
    fi
    if grep -q "hmr: { host:" "$CONFIG_FILE"; then
        sed -i "s/hmr: { host: '[^']*' }/hmr: { host: 'localhost' }/" "$CONFIG_FILE"
    else
        sed -i '/server:/a\        hmr: { host: '\''localhost'\'' },' "$CONFIG_FILE"
    fi
else
    sed -i '/export default defineConfig({/a\    server: {\n        host: '\''0.0.0.0'\'',\n        hmr: { host: '\''localhost'\'' }\n    },' "$CONFIG_FILE"
fi
