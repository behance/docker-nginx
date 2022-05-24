#!/bin/bash -e

# Add the ngx_http_js_module before the start of the "events {" definition.
sed -i '\|^events {|{
  i load_module /usr/lib/nginx/modules/ngx_http_js_module.so;
  i
}' /etc/nginx/nginx.conf
