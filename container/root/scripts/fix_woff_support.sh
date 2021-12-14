#!/bin/bash -e

# Removes legacy woff type
sed -i "/application\/font-woff/d" /etc/nginx/mime.types

# Detects if woff support is already present
if grep -Fxq "font/woff" /etc/nginx/mime.types
then
  echo "Woff type detected, no changes necessary"
else
  echo "Woff type not detected, adding..."
  sed -i "s/}/\n    font\/woff                             woff;&/" /etc/nginx/mime.types
  sed -i "s/}/\n    font\/woff2                            woff2;\n&/g" /etc/nginx/mime.types
fi