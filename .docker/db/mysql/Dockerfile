ARG DB_VERSION

FROM mysql:${DB_VERSION:-latest}

ARG USER_ID
ARG GROUP_ID

ENV MYSQL_MAIN_CONF=/etc/my.cnf

COPY --chmod=0755 \
    permissions.sh \
    db/mysql/cmd.sh \
    db/mysql/healthcheck.sh \
    /usr/local/bin/

RUN permissions.sh mysql

HEALTHCHECK --start-period=12s CMD ["healthcheck.sh"]

CMD ["cmd.sh"]
