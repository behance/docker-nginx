#!/bin/bash
CONFIG_SITE=/etc/nginx/sites-available/default
CONFIG_SERVER=/etc/nginx/nginx.conf

echo '[nginx] setting sensible defaults'

# Configure nginx to use as many workers as there are cores for the running container
# NOTE: worker_processes is only replaced when *not* set to auto
sed -i "s/worker_processes [0-9]\+/worker_processes $(nproc)/" $CONFIG_SERVER
sed -i "s/worker_connections [0-9]\+/worker_connections 1024/" $CONFIG_SERVER

# Uncomment prod-level tokens (none)
sed -i "s/\#\ server_tokens/server_tokens/" $CONFIG_SERVER

echo '[nginx] piping logs to STDOUT'

# Set access/error log, and use them as a placeholder for injecting log_format key
# IMPORTANT: string match the entire default access log path, making access_log + log_format injection idempotent
sed -i "s/access_log \/var\/log\/nginx\/access\.log;/    log_format main \'\$remote_addr - \$remote_user [\$time_local] \"\$request\" \$status \$bytes_sent \"\$http_referer\" \"\$http_user_agent\" ${SERVER_APP_NAME}\';\n access_log \/dev\/stdout main;\n/" $CONFIG_SERVER
sed -i "s/error_log [a-z\/\.\ \;]\+/error_log \/dev\/stdout info;/" $CONFIG_SERVER

if [[ $SERVER_MAX_BODY_SIZE ]]
then
  echo "[nginx] server client max body is ${SERVER_MAX_BODY_SIZE}"
  sed -i "s/client_max_body_size 1m/client_max_body_size ${SERVER_MAX_BODY_SIZE}/" $CONFIG_SITE
fi

if [[ $SERVER_INDEX ]]
then
  echo "[nginx] server index is ${SERVER_INDEX}"
  sed -i "s/index index.html index.htm/index ${SERVER_INDEX}/" $CONFIG_SITE
fi

if [[ $SERVER_GZIP_OPTIONS ]]
then
    # Uncomments all gzip handling options
  sed -i "s/\#\ gzip/gzip/" $CONFIG_SERVER
fi
