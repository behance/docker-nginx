#!/bin/bash

# If build arg for APT_SOURCE is present, will add it to sources for APT
# This will allow packages to be cached locally, speeding build times
PROXY_FILE=/etc/apt/apt.conf.d/01proxy

if [[ $APT_SOURCE ]]
then
  echo "[apt-cache] Adding ${APT_SOURCE} to apt sources"
  echo "Acquire::http::Proxy \"http://${APT_SOURCE}:3142\";" > $PROXY_FILE;
else
  echo "[apt-cache] No APT_SOURCE present"

  # IMPORTANT: remove any leftover proxy files from a parent build, it was most likely not performed in the same place
  if [[ -f $PROXY_FILE ]]
  then
    echo "[apt-cache] removing leftover proxy file"
    rm $PROXY_FILE
  fi
fi
