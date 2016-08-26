FROM ubuntu:14.04
MAINTAINER Bryan Latten <latten@adobe.com>

# Use in multi-phase builds, when an init process requests for the container to gracefully exit, so that it may be committed
# Used with alternative CMD (worker.sh), leverages supervisor to maintain long-running processes
ENV SIGNAL_BUILD_STOP=99 \
    CONTAINER_ROLE=web \
    CONTAINER_PORT=8080 \
    CONF_NGINX_SITE="/etc/nginx/sites-available/default" \
    CONF_NGINX_SERVER="/etc/nginx/nginx.conf" \
    NOT_ROOT_USER=www-data \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_KILL_FINISH_MAXTIME=5000 \
    S6_KILL_GRACETIME=3000

# Ensure base system is up to date
RUN apt-get update && \
    apt-get upgrade -yqq && \
    # Install pre-reqs \
    apt-get install -yqq \
        software-properties-common \
        curl \
    && \
    # Add goss for local testing
    curl -L https://github.com/aelsabbahy/goss/releases/download/v0.2.3/goss-linux-amd64 -o /usr/local/bin/goss && \
    chmod +x /usr/local/bin/goss && \
    apt-get remove --purge -yq curl && \
    # Install latest nginx (development PPA is actually mainline development) \
    add-apt-repository ppa:nginx/development -y && \
    apt-get update -yqq && \
    apt-get install -yqq nginx \
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
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{cache,log}/ && \
    rm -rf /var/lib/apt/lists/ && \
    rm -rf /tmp/* /var/tmp/*

# Overlay the root filesystem from this repo
COPY ./container/root /

# Add S6 overlay build, to avoid having to build from source
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && \
    rm /tmp/s6-overlay-amd64.tar.gz && \
    # Set nginx to listen on defined port \
    sed -i "s/listen [0-9]*;/listen ${CONTAINER_PORT};/" $CONF_NGINX_SITE

RUN goss -g goss.nginx.yaml validate

# Using a non-privileged port to prevent having to use setcap internally
EXPOSE ${CONTAINER_PORT}

# NOTE: intentionally NOT using s6 init as the entrypoint
# This would prevent container debugging if any of those service crash
CMD ["/bin/bash", "/run.sh"]
