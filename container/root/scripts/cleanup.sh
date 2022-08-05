#!/bin/bash

###############################################################################
# Remove any uneeded packages that we install that is not during runtime
###############################################################################

# Running python will generate .pyc files and it will prevent the folder
# from being deleted. Sample warning:
#
# dpkg: warning: while removing python3.10, 
# directory '/usr/lib/python3/dist-packages' not empty so not removed
[[ -d /usr/lib/python3/dist-packages ]] && rm -rf /usr/lib/python3/dist-packages

# Remove unused packages that should not be in the final image
apt-get remove --purge -yq \
  curl \
  gnupg2 \
  lsb-release \
  manpages \
  manpages-dev \
  man-db \
  patch \
  make \
  unattended-upgrades \
  python*
