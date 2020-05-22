#!/usr/bin/with-contenv bash

if [[ $SERVER_APP_NAME ]]
then
  echo "[nginx] adding app name (${SERVER_APP_NAME}) to log format"
  sed -i "s/NGINX_SERVER/${SERVER_APP_NAME}/" $CONF_NGINX_SERVER
else
  echo "[nginx] missing \$SERVER_APP_NAME to add to log lines, please add environment variable"
fi

if [[ $SERVER_SENDFILE ]]
then
  echo "[nginx] server sendfile status is ${SERVER_SENDFILE}"
  sed -i "s/sendfile .*;/sendfile ${SERVER_SENDFILE};/" $CONF_NGINX_SERVER
fi

if [[ $SERVER_MAX_BODY_SIZE ]]
then
  echo "[nginx] server client max body is ${SERVER_MAX_BODY_SIZE}"
  sed -i "s/client_max_body_size .*;/client_max_body_size ${SERVER_MAX_BODY_SIZE};/" $CONF_NGINX_SITE
fi

if [[ $SERVER_INDEX ]]
then
  echo "[nginx] server index is ${SERVER_INDEX}"
  sed -i "s/index .*;/index ${SERVER_INDEX};/" $CONF_NGINX_SITE
fi

if [[ $SERVER_GZIP_OPTIONS ]]
then
  echo "[nginx] enabling gzip"
    # Uncomments all gzip handling options
  sed -i "s/\#gzip/gzip/" $CONF_NGINX_SERVER
fi

if [[ $SERVER_KEEPALIVE ]]
then
  echo "[nginx] setting keepalive ${SERVER_KEEPALIVE}"
  sed -i "s/\keepalive_timeout .*;/keepalive_timeout ${SERVER_KEEPALIVE};/" $CONF_NGINX_SERVER
fi

if [[ $SERVER_WORKER_PROCESSES ]]
then
  echo "[nginx] setting worker processes ${SERVER_WORKER_PROCESSES}"
  sed -i "s/\worker_processes .*;/worker_processes ${SERVER_WORKER_PROCESSES};/" $CONF_NGINX_SERVER
fi

if [[ $SERVER_WORKER_CONNECTIONS ]]
then
  echo "[nginx] setting worker connection limit ${SERVER_WORKER_CONNECTIONS}"
  sed -i "s/\worker_connections .*;/worker_connections ${SERVER_WORKER_CONNECTIONS};/" $CONF_NGINX_SERVER
fi

if [[ $SERVER_LOG_MINIMAL ]]
then
  echo "[nginx] enabling minimal logging"
  sed -i "s/access_log \/dev\/stdout .*;/access_log \/dev\/stdout minimal;/" $CONF_NGINX_SERVER
fi

if [[ $SERVER_LARGE_CLIENT_HEADER_BUFFERS ]]
then
  echo "[nginx] setting large_client_header_buffers to ${SERVER_LARGE_CLIENT_HEADER_BUFFERS}"
  sed -i "s/large_client_header_buffers .*;/large_client_header_buffers ${SERVER_LARGE_CLIENT_HEADER_BUFFERS};/" $CONF_NGINX_SERVER
fi

if [[ $SERVER_CLIENT_HEADER_BUFFER_SIZE ]]
then
  echo "[nginx] setting client_header_buffer_size to ${SERVER_CLIENT_HEADER_BUFFER_SIZE}"
  sed -i "s/client_header_buffer_size .*;/client_header_buffer_size ${SERVER_CLIENT_HEADER_BUFFER_SIZE};/" $CONF_NGINX_SERVER
fi

if [[ $SERVER_CLIENT_BODY_BUFFER_SIZE ]]
then
  echo "[nginx] setting client_body_buffer_size to ${SERVER_CLIENT_BODY_BUFFER_SIZE}"
  sed -i "s/client_body_buffer_size .*;/client_body_buffer_size ${SERVER_CLIENT_BODY_BUFFER_SIZE};/" $CONF_NGINX_SERVER
fi

if [[ $SERVER_ENABLE_HTTPS ]]
then
  echo "[nginx] enabling HTTPS"
  # Uncomment all ssl* directives in site configuration
  sed -i "s/^[ ]*#ssl/  ssl/" $CONF_NGINX_SITE
  # Add SSL to listen directive
  sed -i "s/^[ ]*listen ${CONTAINER_PORT}/  listen ${CONTAINER_PORT} ssl/" $CONF_NGINX_SITE
fi
