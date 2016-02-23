#!/bin/bash

# Entrypoint for utilizing as a worker pool instead of a web server
# Based on configuration, can run multiple instances of a single worker process

SUPERVISOR_CONF=/etc/supervisor/conf.d/worker.conf

# Signal to init processes to avoid any webserver startup
export CONTAINER_ROLE='worker'

# Begin startup sequence
/init.sh

STATUS=$?  # Captures exit code from script that was run

# TODO this exit code detection is also present in run.sh, needs to be combined
if [[ $STATUS == $SIGNAL_BUILD_STOP ]]
then
  echo "[worker] container exit requested"
  exit # Exit cleanly
fi

if [[ $STATUS != 0 ]]
then
  echo "[worker] failed to init"
  exit $STATUS
fi


WORKER_QUANTITY=$1

# Rebuild worker command as properly escaped parameters from shifted input args
# @see http://stackoverflow.com/questions/7535677/bash-passing-paths-with-spaces-as-parameters
shift
WORKER_COMMAND="$@"

if [ -z "$WORKER_COMMAND" ]
then
  echo "[worker] command is required, exiting"
  exit 1
fi

echo "[worker] command: '${WORKER_COMMAND}' quantity: ${WORKER_QUANTITY}"

echo "\
[program:worker]
command=${WORKER_COMMAND}
process_name=%(program_name)s%(process_num)s
numprocs=${WORKER_QUANTITY}
autorestart=true
redirect_stderr=true
stdout_logfile_maxbytes=0
stdout_logfile=/dev/stdout" > $SUPERVISOR_CONF

echo "[worker] entering supervisor"

# Primary command - starting supervisor after writing with worker program config file
exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf --nodaemon
