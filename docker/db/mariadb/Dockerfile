ARG DB_VERSION

FROM mariadb:${DB_VERSION:-latest}

ARG USER_ID
ARG GROUP_ID

COPY permissions.sh /usr/local/bin/
COPY db/mariadb/cmd.sh /usr/local/bin/
COPY db/mariadb/healthcheck.sh /usr/local/bin/

RUN permissions.sh mysql

HEALTHCHECK --start-period=12s CMD ["healthcheck.sh"]

CMD ["cmd.sh"]