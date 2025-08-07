ARG NGINX_VERSION

FROM nginx:${NGINX_VERSION:-stable}-alpine

ARG USER_ID
ARG GROUP_ID

RUN apk update && apk add --no-cache jq openssl python3 py3-pip py3-virtualenv 

RUN python -m venv /opt/venv && \
    . /opt/venv/bin/activate && \
    pip install --upgrade pip && \
    pip install --no-cache-dir crossplane

COPY permissions.sh /usr/local/bin/
RUN permissions.sh nginx

CMD ["cmd.sh"]