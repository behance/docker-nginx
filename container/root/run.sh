#!/bin/bash

echo 'Setting sensible nginx defaults'

# Configure nginx to use as many workers as there are cores for the running container
sed -i "s/worker_processes [0-9]\+/worker_processes $(nproc)/" /etc/nginx/nginx.conf
sed -i "s/worker_connections [0-9]\+/worker_connections 1024/" /etc/nginx/nginx.conf

# Ensure nginx is configured to write logs to STDOUT
sed -i "s/access_log [a-z\/\.\;]\+/            log_format main \'\$remote_addr - \$remote_user [\$time_local] \"\$request\" \$status \$bytes_sent \"\$http_referer\" \"\$http_user_agent\" SERVER_APP_NAME\';\n        access_log \/dev\/stdout main;\n/" /etc/nginx/nginx.conf
sed -i "s/error_log [a-z\/\.\ \;]\+/error_log \/dev\/stdout info;/" /etc/nginx/nginx.conf

echo "Starting Nginx (foreground)"
exec /usr/sbin/nginx -g "daemon off;"
