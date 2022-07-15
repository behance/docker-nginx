#!/bin/bash -ex

# Install nginx per http://nginx.org/en/linux_packages.html#Ubuntu

# Install the prerequisites: 
apt -y update && apt -y install \
  curl \
  gnupg2 \
  ca-certificates \
  lsb-release \
  ubuntu-keyring

# Import an official nginx signing key so apt could verify the packages
# authenticity. Fetch the key: 
curl -s https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

gpg --dry-run --quiet --import --import-options import-show \
  /usr/share/keyrings/nginx-archive-keyring.gpg

# set up the apt repository for stable nginx packages
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
  http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list

# Set up repository pinning to prefer our packages over
# distribution-provided ones:
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
    | tee /etc/apt/preferences.d/99nginx

# Install nginx
apt -y update && apt -y install nginx-light

# Cleanup
# Otherwise dpkg will complain with
# dpkg: warning: while removing python3.10, directory '/usr/lib/python3/dist-packages' not empty so not removed
rm -rf /usr/lib/python3/dist-packages

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