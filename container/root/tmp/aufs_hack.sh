#!/bin/bash

# Use this to wipe the temp files/folders generated when `nginx -t`
# NOTE: must be run after a goss test!
#
# @see https://github.com/docker/docker/issues/20240
#
# In some versions of AUFS, permissions do not set/inherit properly.
# This can cause folders that are created in a different layer than
# they are used to not properly respect permissions.
#
# For example, when testing nginx's configuration, the temp folders
# are generated, but cannot be accessed by nginx while running.

echo "[hack] removing test nginx files and folders"

rm -rfv \
  /tmp/.nginx/client_body \
  /tmp/.nginx/fastcgi_temp \
  /tmp/.nginx/scgi_temp \
  /tmp/.nginx/uwsgi_temp \
  /tmp/.nginx/proxy_temp \
  /tmp/.nginx/nginx.pid
