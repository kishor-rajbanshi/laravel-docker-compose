ARG NGINX_VERSION

FROM nginx:"${NGINX_VERSION:-stable}-alpine"

ARG USER_ID
ARG GROUP_ID

ENV NGINX_DEFAULT_CONF_FILE="/etc/nginx/templates/default.conf"
ENV NGINX_CONF_FILE="/etc/nginx/nginx.conf"

COPY --chmod=0755 \
    permissions.sh \
    nginx/cmd.sh \
    nginx/healthcheck.sh \
    /usr/local/bin/

COPY --chmod=0755 \
    nginx/60-extra-hosts.sh \
    nginx/65-phpmyadmin.sh \
    nginx/70-ssl.sh \
    /docker-entrypoint.d/

COPY --chmod=0644 nginx/default.conf "$NGINX_DEFAULT_CONF_FILE"

RUN apk update && apk add --no-cache jq openssl python3 py3-pip py3-virtualenv 

RUN python -m venv /opt/venv && \
    . /opt/venv/bin/activate && \
    pip install --upgrade pip && \
    pip install --no-cache-dir crossplane

RUN permissions.sh nginx

CMD ["cmd.sh"]
