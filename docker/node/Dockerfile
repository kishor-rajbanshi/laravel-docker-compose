ARG NODE_VERSION

FROM node:${NODE_VERSION:-current}-alpine

ARG USER_ID
ARG GROUP_ID

COPY ./permissions.sh /usr/local/bin/
COPY ./node/entrypoint.sh /usr/local/bin/
COPY ./node/vite.sh /usr/local/bin/

RUN permissions.sh node

USER node

ENTRYPOINT [ "entrypoint.sh" ]