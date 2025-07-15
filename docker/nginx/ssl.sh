#!/bin/sh

set -e

conf_file="/etc/nginx/nginx.conf"
cert_dir="/etc/nginx/ssl"

if [ -z "$(ls -A $cert_dir)" ]; then
    exit 0
fi

apk add --no-cache python3 py3-pip py3-virtualenv jq openssl

python -m venv /opt/venv
. /opt/venv/bin/activate

pip install --upgrade pip
pip install --no-cache-dir crossplane

json_conf_file=$(mktemp)

crossplane parse "$conf_file" -o "$json_conf_file"

jq -c \
    '
    .config[].parsed[] 
    | select(.directive == "server")
    ' "$json_conf_file" | while read -r server; do

    server_name=$(echo "$server" | jq -r '.block[] | select(.directive == "server_name") | .args | join(" ")')

    for cert in "$cert_dir"/*.pem "$cert_dir"/*.crt; do
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

        cert_has_key=0

        for key in "$cert_dir"/*; do
            key_pubkey="$({ openssl pkey -in "$key" -pubout -outform PEM 2>/dev/null || true; })"

            if [ "x$cert_pubkey" = "x$key_pubkey" ]; then
                cert_has_key=1
                break
            fi
        done

        [ "$cert_has_key" -eq 0 ] && continue

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

        json_conf_file_=$(mktemp)

        jq --argjson server "$server" \
            --arg cert "$cert" \
            --arg key "$key" \
            --arg NGINX_SSL_PORT "$NGINX_SSL_PORT" \
            '
            .config |= map(
                if any(.parsed[]; .block == $server.block) then
                    .parsed |= ([{
                        directive: "server",
                        args: [],
                        block: (
                            ($server.block | map(select(.directive == "listen"))) +
                            ($server.block | map(select(.directive == "server_name") | {directive, args})) +
                            [{directive: "return", args: ["301", "https://$host$request_uri"]}]
                        )
                    }] + .) 
                else
                    .
                end
            ) | .config |= map(
                .parsed |= map(
                    if .block == $server.block then
                        .block |= (
                            map(
                                if .directive == "listen" and (.args[0] | startswith("[::]:")) then
                                    .args = ["[::]:"+$NGINX_SSL_PORT]
                                elif .directive == "listen" then
                                    .args = [$NGINX_SSL_PORT, "ssl"]
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
                                [{"directive": "listen", "args": [$NGINX_SSL_PORT, "ssl"]}]
                            else [] end)
                            +
                            (if any(.[]; .directive == "ssl_certificate") | not then
                                [{"directive": "ssl_certificate", "args": [$cert]}]
                            else [] end)
                            +
                            (if any(.[]; .directive == "ssl_certificate_key") | not then
                                [{"directive": "ssl_certificate_key", "args": [$key]}]
                            else [] end)
                        )
                    else
                        .
                    end
                )
            )' "$json_conf_file" >"$json_conf_file_" && mv -f $json_conf_file_ $json_conf_file
    done
done

crossplane build --force $json_conf_file && rm -rf $json_conf_file