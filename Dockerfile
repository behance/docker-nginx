FROM alpine:3.3
MAINTAINER Bryan Latten <latten@adobe.com>

# Use in multi-phase builds, when an init process requests for the container to gracefully exit, so that it may be committed
# Used with alternative CMD (worker.sh), leverages supervisor to maintain long-running processes
ENV SIGNAL_BUILD_STOP=99 \
    CONTAINER_ROLE=web \
    CONF_NGINX_SITE="/etc/nginx/sites-available/default" \
    CONF_NGINX_SERVER="/etc/nginx/nginx.conf" \
    NOT_ROOT_USER=docker

# Create an unprivileged user
RUN adduser -D -S -H $NOT_ROOT_USER

# IMPORTANT: update is *part* of the upgrade statement to ensure the latest on each build.
# Note: sed/grep replace the less performant, less functional busybox versions
RUN apk update && \
    apk upgrade && \
    apk add \
        sed \
        grep \
        supervisor \
        nginx \
    && \
    rm -rf /var/cache/apk/*

# Overlay the root filesystem from this repo
COPY ./container/root /

EXPOSE 80
CMD ["/bin/sh", "/run.sh"]
