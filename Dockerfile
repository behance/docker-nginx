FROM ubuntu:14.04
MAINTAINER Bryan Latten <latten@adobe.com>

# Use in multi-phase builds, when an init process requests for the container to gracefully exit, so that it may be committed
# Used with alternative CMD (worker.sh), leverages supervisor to maintain long-running processes
ENV SIGNAL_BUILD_STOP=99 \
    CONTAINER_ROLE=web \
    CONF_NGINX_SITE="/etc/nginx/sites-available/default" \
    CONF_NGINX_SERVER="/etc/nginx/nginx.conf" \
    NOT_ROOT_USER=docker

# Create an unprivileged user
RUN useradd -r -s /bin/false $NOT_ROOT_USER

RUN apt-get update && \
    apt-get install -yq \
        openssl \
        ca-certificates \
        software-properties-common \
        supervisor \
        nano \
    && \
    rm -rf /var/lib/apt/lists/*

# Install latest nginx (development PPA is actually mainline development)
RUN add-apt-repository ppa:nginx/development -y && \
    apt-get update -yq && \
    apt-get install -yq nginx \
    && \
    rm -rf /var/lib/apt/lists/* \
    && \
    setcap cap_net_bind_service=+ep /usr/sbin/nginx

# # Overlay the root filesystem from this repo
COPY ./container/root /

USER www-data
EXPOSE 80
CMD ["/bin/bash", "/run.sh"]
