FROM ubuntu:14.04.3
MAINTAINER Bryan Latten <latten@adobe.com>

# Use in multi-phase builds, when an init process requests for the container to gracefully exit, so that it may be committed
ENV SIGNAL_BUILD_STOP 99

# Used with alternative CMD (worker.sh), leverages supervisor to maintain long-running processes
ENV CONTAINER_ROLE=web

# IMPORTANT: update is *part* of the upgrade statement to ensure the latest on each build.
# Installs pre-reqs, security updates
RUN apt-get update && \
    apt-get upgrade -yq && \
    apt-get -yq install \
        openssl \
        ca-certificates \
        software-properties-common \
        supervisor \
        nano

# Install latest nginx (development PPA is actually mainline development)
RUN add-apt-repository ppa:nginx/development -y && \
    apt-get update -yq && \
    apt-get install -yq nginx

# Overlay the root filesystem from this repo
COPY ./container/root /

EXPOSE 80
CMD ["/bin/bash", "/run.sh"]
