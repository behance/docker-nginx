FROM behance/docker-base:2.1
MAINTAINER Bryan Latten <latten@adobe.com>

ENV CONTAINER_ROLE=web \
    CONTAINER_PORT=8080 \
    CONF_NGINX_SITE="/etc/nginx/sites-available/default" \
    CONF_NGINX_SERVER="/etc/nginx/nginx.conf" \
    NOT_ROOT_USER=www-data

# Using a non-privileged port to prevent having to use setcap internally
EXPOSE ${CONTAINER_PORT}

# - Update security packages, only
RUN /bin/bash -e /security_updates.sh && \
    # Install pre-reqs \
    apt-get install --no-install-recommends -yqq \
        software-properties-common \
    && \
    # Install latest nginx (development PPA is actually mainline development) \
    add-apt-repository ppa:nginx/development -y && \
    apt-get update -yqq && \
    apt-get install -yqq --no-install-recommends \
        nginx-light \
    && \
    # Perform cleanup, ensure unnecessary packages are removed \
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
COPY ./container/root /

# Set nginx to listen on defined port
# NOTE: order of operations is important, new config had to already installed from repo (above)
RUN sed -i "s/listen [0-9]*;/listen ${CONTAINER_PORT};/" $CONF_NGINX_SITE && \
    # Make temp directory for .nginx runtime files \
    mkdir /tmp/.nginx

RUN goss -g /tests/nginx/base.goss.yaml validate && \
    /aufs_hack.sh

# NOTE: intentionally NOT using s6 init as the entrypoint
# This would prevent container debugging if any of those service crash
CMD ["/bin/bash", "/run.sh"]
