#!/bin/bash -e

# Entrypoint to run migrations.
# Instructions:
# ./migration.sh -p <PATH_TO_SCRIPT> -s <SCRIPT>
#
# examle: ./migration.sh -p /app/migrations/scripts -s cool-migration-script.php

# Signal to init processes to avoid any webserver startup
export CONTAINER_ROLE='migration'

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
while getopts "p:s:" opt
do
  case $opt in
    p)
      # path name
      MIGRATION_PATH=$OPTARG
      echo "OPTARG: ${OPTARG}"
      echo "MIGRATION_PATH: $MIGRATION_PATH"
      ;;
    s)
      # script name
      MIGRATION_SCRIPT=$OPTARG
      ;;
  esac
done

# Validate path
if [[ -z $MIGRATION_PATH ]]
then
  echo "ERROR: migration.sh - MIGRATION_PATH not set"
  exit 99
fi

if [[ ! -d $MIGRATION_PATH ]]
then
  echo "ERROR: migration.sh - Invalid MIGRATION_PATH: $MIGRATION_PATH"
  exit 99
fi

# validate script
if [[ -z $MIGRATION_SCRIPT ]]
then
  echo "ERROR: migration.sh - MIGRATION_SCRIPT not set"
  exit 99
fi

if [[ ! -f $MIGRATION_PATH/$MIGRATION_SCRIPT ]]
then
  echo "ERROR: migration.sh - Invalid MIGRATION_SCRIPT: $MIGRATION_SCRIPT"
  exit 99
fi

# Execute migration
$MIGRATION_PATH/$MIGRATION_SCRIPT
