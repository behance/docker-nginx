#!/bin/bash
RUN_SCRIPTS=/run.d
STATUS=0

# Run shell scripts (ending in .sh) in run.d directory

# When .sh run scripts fail (exit non-zero), container run will fail
# NOTE: if a .sh script exits with 99, this is our stop signal, container will exit cleanly

for file in $RUN_SCRIPTS/*.sh; do

  echo "[run.d] executing ${file}"

  /bin/bash $file

  STATUS=$?  # Captures exit code from script that was run

  if [[ $STATUS == 99 ]]
  then
    echo "[run.d] exit signalled - ${file}"
    exit # Exit cleanly
  fi

  if [[ $STATUS != 0 ]]
  then
    echo "[run.d] failed executing - ${file}"
    exit $STATUS
  fi

done

echo "[nginx] start (foreground)"
exec /usr/sbin/nginx -g "daemon off;"
