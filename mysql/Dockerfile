ARG MYSQL_VERSION

FROM mysql:${MYSQL_VERSION:-latest}

ARG UID
ARG GID

COPY ./mysql/cmd.sh /tmp/cmd.sh
COPY ./mysql/configure.sh /tmp/configure.sh
COPY ./conf.d/mysql.cnf /etc/mysql/conf.d/mysql.cnf
COPY ./scripts /tmp

RUN /tmp/install-shadow.sh
RUN /tmp/user-group-mod.sh mysql
RUN /tmp/configure.sh

CMD ["/tmp/cmd.sh"]