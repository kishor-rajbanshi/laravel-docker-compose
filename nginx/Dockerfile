ARG NGINX_VERSION

FROM nginx:${NGINX_VERSION:-stable}-alpine

ARG UID
ARG GID
ARG NGINX_SERVER_NAME

COPY ./nginx/cmd.sh /tmp/cmd.sh
COPY ./build.d/nginx.sh /tmp/configure.sh
COPY ./conf.d/nginx.conf /etc/nginx/conf.d/default.conf
COPY ./scripts /tmp

RUN /tmp/install-shadow.sh
RUN /tmp/user-group-mod.sh nginx
RUN /tmp/configure.sh

CMD ["/tmp/cmd.sh"]
