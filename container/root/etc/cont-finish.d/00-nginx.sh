#!/usr/bin/execlineb -P

foreground { nginx -s quit }
echo "[finish nginx] shutting down gracefully"
