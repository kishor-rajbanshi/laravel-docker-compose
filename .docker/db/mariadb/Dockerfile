ARG DB_VERSION

FROM mariadb:${DB_VERSION:-latest}

ARG USER_ID
ARG GROUP_ID

COPY --chmod=0755 \
    permissions.sh \
    db/mariadb/cmd.sh \
    db/mariadb/healthcheck.sh \
    /usr/local/bin/

RUN permissions.sh mysql

HEALTHCHECK --start-period=12s CMD ["healthcheck.sh"]

CMD ["cmd.sh"]