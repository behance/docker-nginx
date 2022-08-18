# Environment Variables

Supported env vars

Variable | Example | Description
--- | --- | ---
SERVER_MAX_BODY_SIZE | SERVER_MAX_BODY_SIZE=4M | Allows the downstream application to specify a non-default `client_max_body_size` configuration for the `server`-level directive in `/etc/nginx/sites-available/default`
SERVER_INDEX | SERVER_INDEX index.html index.html index.php | Changes the default pages to hit for folder and web roots
SERVER_APP_NAME | SERVER_APP_NAME='view' | Gets appended to the default logging format
SERVER_GZIP_OPTIONS | SERVER_GZIP_OPTIONS=1 | Allows default set of static content to be served gzipped
SERVER_SENDFILE | SERVER_SENDFILE=off | Allows runtime to specify value of nginx's `sendfile` (default, on)
SERVER_ENABLE_HTTPS | SERVER_ENABLE_HTTPS=true | Enable encrypted transmission using certificates
SERVER_ENABLE_NGX_BROTLI | SERVER_ENABLE_NGX_BROTLI=true | Enable Brotli compression (default: false)
SERVER_ENABLE_NGX_HTTP_JS | SERVER_ENABLE_NGX_HTTP_JS=true | Enable nginx njs module (default: false)
SERVER_KEEPALIVE | SERVER_KEEPALIVE=30 | Define HTTP 1.1's keepalive timeout
SERVER_WORKER_PROCESSES | SERVER_WORKER_PROCESSES=4 | Set to the number of cores in the machine, or the number of cores allocated to container
SERVER_WORKER_CONNECTIONS | SERVER_WORKER_CONNECTIONS=2048 | Sets up the number of connections for worker processes
SERVER_CLIENT_HEADER_BUFFER_SIZE | SERVER_CLIENT_HEADER_BUFFER_SIZE=16k | [docs](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_header_buffer_size)
SERVER_LARGE_CLIENT_HEADER_BUFFERS | SERVER_LARGE_CLIENT_HEADER_BUFFERS=8 16k | [docs](http://nginx.org/en/docs/http/ngx_http_core_module.html#large_client_header_buffers)
SERVER_CLIENT_BODY_BUFFER_SIZE | SERVER_CLIENT_BODY_BUFFER_SIZE=128k | [docs](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_buffer_size)
SERVER_LOG_MINIMAL | SERVER_LOG_MINIMAL=1 | Minimize the logging format, appropriate for development environments
SERVER_SHOW_NGINX_CONF | SERVER_SHOW_NGINX_CONF=true | Dump the contents of nginx.conf. Useful when debugging the config during start up (default: false)
S6_KILL_FINISH_MAXTIME | S6_KILL_FINISH_MAXTIME=55000 | The maximum time (in ms) a script in /etc/cont-finish.d could take before sending a KILL signal to it. Take into account that this parameter will be used per each script execution, it's not a max time for the whole set of scripts. This value has a max of 65535 on Alpine variants.
S6_KILL_GRACETIME | S6_KILL_GRACETIME=500 | Wait time (in ms) for S6 finish scripts before sending kill signal

## Startup/Runtime Modification

- Environment variables are used to drive nginx configuration at runtime
- See [here](https://github.com/behance/docker-base#startupruntime-modification) for more advanced options

