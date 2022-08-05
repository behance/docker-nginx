#!/bin/bash -e

# Removes legacy woff type
sed -i "/application\/font-woff/d" /etc/nginx/mime.types

# Detects if woff support is already present
# From: https://linux.die.net/man/1/grep
# -F - Interpret PATTERN as a list of fixed strings, separated by newlines, 
#      any of which is to be matched
# -q - Quiet; do not write anything to standard output. Exit immediately with
#      zero status if any match is found, even if an error was detected
if grep -Fq "font/woff" /etc/nginx/mime.types
then
  echo "Woff type detected, no changes necessary"
else
  echo "Woff type not detected, adding..."
  sed -i "s/}/\n    font\/woff                             woff;&/" /etc/nginx/mime.types
  sed -i "s/}/\n    font\/woff2                            woff2;\n&/g" /etc/nginx/mime.types
fi
