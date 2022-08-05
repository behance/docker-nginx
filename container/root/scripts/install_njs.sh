#!/bin/bash -e

###############################################################################
# Install nginx NJS module
# Ref: https://nginx.org/en/docs/njs/install.html
###############################################################################

# https://jira.corp.adobe.com/browse/ETHOS-36876
apt-get -y update && \
    apt-get -y \
        -o Dpkg::Options::="--force-confdef" \
        -o Dpkg::Options::="--force-confold" \
        install nginx-module-njs

# Remove any debug packags
rm /etc/nginx/modules/ngx_*-debug.so
