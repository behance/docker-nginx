#!/bin/bash -e

# Replace existing s6-setuidgid binary with the script we've written
mv /bin/s6-setuidgid /scripts/s6-setuidgid && mv /s6-setuidgid /bin/

# Create the nginx error log file before nginx does so that nginx does not complain about permissions on this file
touch /var/log/nginx/error.log

# Assign ownership of required scripts/directories to the non root user
rm /var/run && mkdir -p /var/run/s6 && chown -R ${NOT_ROOT_USER} /etc/services.d/ /etc/services-available/ /bin/s6-* /etc/nginx/ /tmp/ /var/

chmod 755 -R /etc/s6/ /bin/s6-* /scripts/s6-setuidgid /etc/nginx/ /var/

# Make s6 give non root user ownership to user provided files instead of root
# List of files/folders given ownership available here: https://github.com/just-containers/s6-overlay/blob/master/builder/overlay-rootfs/etc/s6/init/init-stage2-fixattrs.txt
sed -i "s/root/${NOT_ROOT_USER}/" /etc/s6/init/init-stage2-fixattrs.txt