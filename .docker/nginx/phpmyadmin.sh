#!/bin/sh

set -e

me=$(basename "$0")

cmd_log() {
    if [ -z "${NGINX_CMD_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

if [ "$PHPMYADMIN_ENABLED" != "true" ] || { [ "$DB_CONNECTION" != "mysql" ] && [ "$DB_CONNECTION" != "mariadb" ]; }; then
    cmd_log "$me: info: Skipping phpmyadmin - not enabled or unsupported database"
    exit 0
fi

cmd_log "$me: info: Setting up phpmyadmin"

phpmyadmin_block='{
    "directive": "location",
    "args": ["/phpmyadmin"],
    "block": [
        { "directive": "root", "args": ["\/var\/www"] },
        { "directive": "index", "args": ["index.php"] },
        {
            "directive": "location",
            "args": ["~", "^/phpmyadmin/(.+\\.php)$"],
            "block": [
                { "directive": "include", "args": ["fastcgi_params"] },
                { "directive": "fastcgi_pass", "args": ["phpmyadmin:9000"] },
                { "directive": "fastcgi_param", "args": ["SCRIPT_FILENAME", "/var/www/html/$1"] },
                { "directive": "fastcgi_param", "args": ["PATH_INFO", "/$1"] }
            ]
        },
        {
            "directive": "location",
            "args": ["~*", "\\.(js|css|png|jpg|jpeg|gif|ico|svg)$"],
            "block": [
                { "directive": "expires", "args": ["max"] },
                { "directive": "log_not_found", "args": ["off"] }
            ]
        }
    ]
}'

json_conf_file=$(mktemp)

. /opt/venv/bin/activate

crossplane parse /etc/nginx/nginx.conf > $json_conf_file

has_position=$(
    cat $json_conf_file | jq '[.config[].parsed[]
        | select(.directive=="server")
        | .block[]?
        | select(.directive=="include" and .args[0] == "*phpmyadmin")
      ] | any'
)

json_conf_file_=$(mktemp)

if [ "$has_position" = true ]; then
    cmd_log "$me: info: Detected phpMyAdmin include directive. Injecting configuration as specified."

    jq --argjson phpmyadmin_block "$phpmyadmin_block" '
        .config[].parsed[] |= (
            if .directive == "server" and any(.block[]?; .directive == "include" and .args[0] == "*phpmyadmin") then 
                .block += [$phpmyadmin_block]
            else 
                .
            end
        )
    ' <"$json_conf_file" >"$json_conf_file_" && mv -f $json_conf_file_ $json_conf_file
else
    cmd_log "$me: info: Appending configuration to the first server block."

    jq --argjson phpmyadmin_block "$phpmyadmin_block" '
        .config[].parsed |=(
            reduce range(0; length) as $i (
                {added: false, data: .};
                if (.added == false) and (.data[$i].directive == "server") then
                    {added: true, data: (.data[$i].block += [$phpmyadmin_block] | .data)}
                else
                    {added: .added, data: .data}
                end
            )
        ).data
    ' <"$json_conf_file" > "$json_conf_file_" && mv -f "$json_conf_file_" "$json_conf_file"
fi

crossplane build --force $json_conf_file && rm -rf $json_conf_file
