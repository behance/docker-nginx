#!/bin/bash

# Validate that env config overrides are acceptable to nginx
# Suppress output, unless it fails
nginx -t &> /dev/null

# Quick and dirty, if the above has failed, re-run it without suppressing output
if [ $? == 1 ]; then
  nginx -t
fi
