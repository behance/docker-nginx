FROM behance/docker-base:4.0-ubuntu-20.04

# Use in multi-phase builds, when an init process requests for the container to gracefully exit, so that it may be committed
# Used with alternative CMD (worker.sh), leverages supervisor to maintain long-running processes
ENV CONTAINER_ROLE=web \
    CONTAINER_PORT=8080 \
    CONF_NGINX_SITE="/etc/nginx/sites-available/default" \
    CONF_NGINX_SERVER="/etc/nginx/nginx.conf" \
    NOT_ROOT_USER=www-data \
    S6_KILL_FINISH_MAXTIME=55000

# Using a non-privileged port to prevent having to use setcap internally
EXPOSE ${CONTAINER_PORT}

# - Update security packages, plus ca-certificates required for https
# - Install pre-reqs
# - Install latest nginx (development PPA is actually mainline development)
# - Perform cleanup, ensure unnecessary packages are removed
RUN /bin/bash -e /security_updates.sh && \
    apt-get install --no-install-recommends -yqq \
        software-properties-common \
    && \
    add-apt-repository ppa:ondrej/nginx -y && \
    apt-get update -yqq && \
    apt-get install -yqq --no-install-recommends \
        nginx-light \
        ca-certificates \
    && \
    apt-get remove --purge -yq \
        manpages \
        manpages-dev \
        man-db \
        patch \
        make \
        unattended-upgrades \
        python* \
    && \
    /bin/bash -e /clean.sh

# Overlay the root filesystem from this repo
COPY --chown=www-data ./container/root /

# Set nginx to listen on defined port
# NOTE: order of operations is important, new config had to already installed from repo (above)
# - Make temp directory for .nginx runtime files
# - Fix woff mime type support
# Set permissions to allow image to be run under a non root user
RUN sed -i "s/listen [0-9]*;/listen ${CONTAINER_PORT};/" $CONF_NGINX_SITE && \
    mkdir /tmp/.nginx && \
    /bin/bash -e /scripts/fix_woff_support.sh && \
    /bin/bash -e /scripts/set_permissions.sh

RUN goss -g /tests/ubuntu/nginx.goss.yaml validate && \
    /aufs_hack.sh
