#!/bin/bash
RUN_SCRIPTS=/run.d

# Run shell scripts (ending in .sh) in run.d directory, if any
for file in $RUN_SCRIPTS/*.sh; do
  echo "[run.d] executing ${file}"
  /bin/bash $file
done

echo "[nginx] starting (foreground)"
exec /usr/sbin/nginx -g "daemon off;"
