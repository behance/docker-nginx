FROM behance/docker-base:1.6
MAINTAINER Bryan Latten <latten@adobe.com>

ARG CONTAINER_PORT=8080
ARG CONTAINER_SSL

ENV CONTAINER_ROLE=web \
    CONF_NGINX_SITE="/etc/nginx/sites-available/default" \
    CONF_NGINX_SERVER="/etc/nginx/nginx.conf" \
    NOT_ROOT_USER=www-data

# Using a non-privileged port to prevent having to use setcap internally
EXPOSE ${CONTAINER_PORT}

# - Update security packages, only, plus ca-certificates for https
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
    apt-get install -yqq --no-install-recommends \
        ca-certificates \
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

# Uncomment the ssl directives
RUN /bin/bash -c 'if [[ $CONTAINER_SSL ]]; then sed -ig "s/^[ ]*#ssl/  ssl/" $CONF_NGINX_SITE; fi;'

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
