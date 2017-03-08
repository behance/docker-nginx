#!/bin/bash -e

# Entrypoint to run scripts
# Instructions:
# ./command.sh -s <COOL_COMMAND>
#
# example: ./command.sh -s /app/migrations/scripts/cool-command-script.php
#
# NOTE: this is currently only written with the `-s` argument to run a script.
# this *could* be expanded to handle any arbitrary command.

# Signal to init processes to avoid any webserver startup
export CONTAINER_ROLE='command'

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

# Get the script name
while getopts "s:" opt
do
  case $opt in
    s)
      # script name
      COMMAND_SCRIPT=$OPTARG
      echo "COMMAND_SCRIPT: $COMMAND_SCRIPT"
      ;;
  esac
done

# Validate script exists
if [[ -z $COMMAND_SCRIPT ]]
then
  echo "ERROR: command.sh - COMMAND_SCRIPT not set"
  exit -1
fi

if [[ ! -f $COMMAND_SCRIPT ]]
then
  echo "ERROR: command.sh - Invalid COMMAND_SCRIPT : $COMMAND_SCRIPT"
  exit -1
fi

# Execute script
$COMMAND_SCRIPT
