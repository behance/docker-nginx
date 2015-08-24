FROM ubuntu:14.04.2
MAINTAINER Bryan Latten <latten@adobe.com>

# Use in multi-phase builds, when an init process requests for the container to gracefully exit, so that it may be committed
ENV SIGNAL_BUILD_STOP 99

# Used with alternative CMD (worker.sh), leverages supervisor to maintain long-running processes
ENV CONTAINER_ROLE=web

# Install pre-reqs, security updates
RUN apt-get update && \
    apt-get upgrade -yq && \
    apt-get -yq install \
        openssl=1.0.1f-1ubuntu2.15 \
        ca-certificates=20141019ubuntu0.14.04.1 \
        software-properties-common \
        supervisor \
        nano

# Install latest nginx-stable
RUN add-apt-repository ppa:nginx/stable -y && \
    apt-get update -yq && \
    apt-get install -yq nginx=1.8.0-1+trusty1

# Overlay the root filesystem from this repo
COPY ./container/root /

EXPOSE 80
CMD ["/bin/bash", "/run.sh"]
