#!/bin/bash

# Ensure that worker entrypoint does not also run nginx processes
if [ $CONTAINER_ROLE == 'web' ]
then
  echo '[run] enabling web server'

  # Enable nginx as a supervised service
  if [ -d /etc/services.d/nginx ]
  then
    echo '[run] web server already enabled'
  else
    ln -s /etc/services-available/nginx /etc/services.d/nginx
  fi
fi
