#!/bin/bash -e

# Replace existing s6-setuidgid binary with the script we've written
mv /bin/s6-setuidgid /scripts/s6-setuidgid && mv /s6-setuidgid /bin/

# Create the nginx error log file before nginx does so that nginx does not complain about permissions
touch /var/log/nginx/error.log

# Assign ownership of required scripts to the non root user
rm /var/run && mkdir -p /var/run/s6 && chown -R ${NOT_ROOT_USER} /var/run/s6/ /etc/services.d/ /etc/services-available/ /bin/s6-* /etc/nginx/ /var/lib/ /var/log/nginx/error.log /tmp/

chmod 755 -R /etc/s6/ /etc/cont-init.d/ /etc/cont-finish.d/ /bin/s6-* /scripts/s6-setuidgid /etc/nginx/