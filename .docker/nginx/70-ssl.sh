#!/bin/sh

set -e

conf_file="/etc/nginx/nginx.conf"
cert_dir="/etc/nginx/ssl"

me=$(basename "$0")

cmd_log() {
    if [ -z "${NGINX_CMD_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

if [ -z "$(ls -A $cert_dir)" ]; then
    cmd_log "$me: info: $cert_dir is empty, skipping configuration"
    exit 0
fi

cmd_log "$me: info: $cert_dir is not empty, will attempt to perform configuration"

. /opt/venv/bin/activate

json_conf_file=$(mktemp)

crossplane parse "$conf_file" -o "$json_conf_file"

jq -c '.config[].parsed[] | select(.directive == "server")' "$json_conf_file" |
    while read -r server; do

        server_name=$(echo "$server" | jq -r '.block[] | select(.directive == "server_name") | .args | join(" ")')

        cmd_log "$me: info: Searching for SSL certificate associated with \"$server_name\""

        for cert in "$cert_dir"/*; do
            cert_domains=$(openssl x509 -in "$cert" -noout -text 2>/dev/null | awk '
                /X509v3 Subject Alternative Name/ {
                    getline
                    gsub(/^ +| +$/, "")
                    gsub(/DNS:/, "")
                    gsub(/, */, " ")
                    print
                }' | awk '{$1=$1; print}' | sort)

            [ -z "$cert_domains" ] && continue

            cert_pubkey="$(openssl x509 -in "$cert" -pubkey -noout)"

            server_name_matches_cert=1

            for domain in $server_name; do
                case " $cert_domains " in
                *" $domain "*) ;;
                *)
                    server_name_matches_cert=0
                    break
                    ;;
                esac
            done

            [ "$server_name_matches_cert" -eq 1 ] || continue

            cmd_log "$me: info: SSL certificate for \"$server_name\" found at $cert, proceeding with configuration"

            cert_has_key=0

            for key in "$cert_dir"/*; do
                key_pubkey="$({ openssl pkey -in "$key" -pubout -outform PEM 2>/dev/null || true; })"

                if [ "x$cert_pubkey" = "x$key_pubkey" ]; then
                    cert_has_key=1
                    break
                fi
            done

            [ "$cert_has_key" -eq 0 ] && {
                cmd_log "$me: warning: Key for $cert not found, skipping configuration"
                continue
            }

            json_conf_file_=$(mktemp)

            jq \
                --argjson server "$server" \
                --arg cert "$cert" \
                --arg key "$key" \
                --arg NGINX_SSL_PORTS "$NGINX_SSL_PORTS" '
                .config |= map(
                    if any(.parsed[]; .block == $server.block) then
                        .parsed |= ([{
                            directive: "server",
                            args: [],
                            block: (
                                ($server.block | map(select(.directive == "listen" and (.args[0] | startswith("unix:") | not)))) +
                                ($server.block | map(select(.directive == "server_name") | {directive, args})) +
                                [{directive: "return", args: ["301", "https://$host$request_uri"]}]
                            )
                        }] + .)
                    else
                        .
                    end
                ) 
                | .config |= map(
                    .parsed |= map(
                        if .block == $server.block then
                            ([
                                .block[]
                                | select(.directive == "include" and (.args[0] | test("^ssl_port\\*\\d+")))
                                | .args[0] | sub("^ssl_port\\*"; "")
                            ] | first) as $ssl_port

                            | .block |= (
                                map(
                                    if .directive == "listen" then
                                        if (.args[0] | startswith("unix:")) then
                                            .
                                        elif (.args[0] | test("^[0-9]+$")) then
                                            .args[0] = ($ssl_port // $NGINX_SSL_PORTS)
                                        else
                                            .args[0] as $a0
                                            | ($a0 | split(":")) as $parts
                                            | ($parts | if length>0 then .[-1] else "" end | test("^[0-9]+$")) as $last_is_num
                                            | if $last_is_num then
                                                .args[0] = (($parts[0:-1] | join(":")) + ":" + ($ssl_port // $NGINX_SSL_PORTS))
                                            else
                                                .args[0] = ($a0 + ":" + ($ssl_port // $NGINX_SSL_PORTS))
                                            end
                                        end
                                        | .args = [.args[0]] + ((.args[1:] // []) | map(select(. != "ssl")) + ["ssl"])
                                    elif .directive == "ssl_certificate" then
                                        .args = [$cert]
                                    elif .directive == "ssl_certificate_key" then
                                        .args = [$key]
                                    else
                                        .
                                    end
                                )
                                +
                                (if any(.[]; .directive == "listen") | not then
                                    [{ directive: "listen", args: [($ssl_port // $NGINX_SSL_PORTS), "ssl"] }]
                                else [] end)
                                +
                                (if any(.[]; .directive == "ssl_certificate") | not then
                                    [{"directive": "ssl_certificate", "args": [$cert]}]
                                else [] end)
                                +
                                (if any(.[]; .directive == "ssl_certificate_key") | not then
                                    [{"directive": "ssl_certificate_key", "args": [$key]}]
                                else [] end)
                                +
                                (if any(.[]; .directive == "ssl_protocols") | not then
                                    [{"directive": "ssl_protocols", "args": ["TLSv1.2", "TLSv1.3"]}]
                                else [] end)
                                +
                                (if any(.[]; .directive == "ssl_ciphers") | not then
                                    [{"directive": "ssl_ciphers", "args": ["HIGH:!aNULL:!MD5"]}]
                                else [] end)
                            )
                        else
                            .
                        end
                    )
                )' <"$json_conf_file" >"$json_conf_file_" && mv -f $json_conf_file_ $json_conf_file

            continue 2
        done

        cmd_log "$me: warning: Certificate or key associated with \"$server_name\" not found, skipping configuration"
    done

crossplane build --force $json_conf_file && rm -rf $json_conf_file

cmd_log "$me: info: Configuration complete"
