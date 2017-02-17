#!/usr/bin/with-contenv bash

# HACK: pre-existing named pipe for STDOUT, anything written to pipe must be output
cat <> /tmp/stdout 1>&2 &
