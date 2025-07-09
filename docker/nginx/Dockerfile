ARG NGINX_VERSION

FROM nginx:${NGINX_VERSION:-stable}-alpine

ARG USER_ID
ARG GROUP_ID

COPY permissions.sh /usr/local/bin/

RUN permissions.sh nginx

CMD ["cmd.sh"]