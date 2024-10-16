ARG MARIADB_VERSION

FROM mariadb:${MARIADB_VERSION:-latest}

ARG UID
ARG GID

COPY ./mariadb/cmd.sh /tmp/cmd.sh
COPY ./build.d/mariadb.sh /tmp/configure.sh
COPY ./conf.d/mariadb.cnf /etc/mysql/conf.d/mariadb.cnf
COPY ./scripts /tmp

RUN /tmp/install-shadow.sh
RUN /tmp/user-group-mod.sh mysql
RUN /tmp/configure.sh

CMD ["/tmp/cmd.sh"]