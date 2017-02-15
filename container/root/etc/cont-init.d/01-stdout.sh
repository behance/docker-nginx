#!/usr/bin/with-contenv bash

# STDOUT happens to be a very special "file" that is has Docker magic applied to it
# Unfortunately, permissions are flaky between builds, sometimes causing unprivileged users
# to hit issues when attempting to write to STDOUT

# Hack: add others read/write back in at runtime :/
chmod o+rw /dev/stdout
