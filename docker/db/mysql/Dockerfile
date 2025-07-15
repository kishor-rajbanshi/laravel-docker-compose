ARG DB_VERSION

FROM mysql:${DB_VERSION:-latest}

ARG USER_ID
ARG GROUP_ID

COPY permissions.sh /usr/local/bin/
COPY db/mysql/cmd.sh /usr/local/bin/
COPY db/mysql/healthcheck.sh /usr/local/bin/

RUN permissions.sh mysql

HEALTHCHECK --start-period=12s CMD ["healthcheck.sh"]

CMD ["cmd.sh"]