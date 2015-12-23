FROM ubuntu:14.04.3
MAINTAINER Bryan Latten <latten@adobe.com>

# Use in multi-phase builds, when an init process requests for the container to gracefully exit, so that it may be committed
ENV SIGNAL_BUILD_STOP 99

# Used with alternative CMD (worker.sh), leverages supervisor to maintain long-running processes
ENV CONTAINER_ROLE=web

# Used to pass in an apt source, for leveraging a local package source at build-time
ARG APT_SOURCE

ADD ./container/root/apt-cache.sh /

# IMPORTANT: update must be part of the upgrade statement to ensure the latest on each build
# Installs pre-reqs, security updates
RUN ./apt-cache.sh && \
    apt-get update && \
    apt-get upgrade -yq && \
    apt-get -yq install \
        openssl \
        ca-certificates \
        software-properties-common \
        supervisor \
        nano

# Install latest nginx-stable
RUN add-apt-repository ppa:nginx/stable -y && \
    apt-get update -yq && \
    apt-get install -yq nginx=1.8.0-1+trusty1

# IMPORTANT: since each child will be built in seemingly different environment, re-run this build-arg processor in a child
ONBUILD ./apt-cache.sh

# Overlay the root filesystem from this repo
COPY ./container/root /

EXPOSE 80
CMD ["/bin/bash", "/run.sh"]
