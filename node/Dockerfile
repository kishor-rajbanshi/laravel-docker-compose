ARG NODE_VERSION

FROM node:${NODE_VERSION:-current}-alpine

ARG UID
ARG GID

COPY ./node/entrypoint.sh /tmp/entrypoint.sh
COPY ./node/setup-vite.sh /tmp/setup-vite.sh
COPY ./build.d/node.sh /tmp/configure.sh
COPY ./scripts /tmp

RUN /tmp/install-shadow.sh
RUN /tmp/user-group-mod.sh node
RUN /tmp/configure.sh

USER node

ENTRYPOINT ["/tmp/entrypoint.sh"]
