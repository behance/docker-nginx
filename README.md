# docker-nginx

https://hub.docker.com/r/behance/docker-nginx/tags/

Ubuntu used by default
Alpine builds available tagged as `-alpine`
Centos builds available tagged as `-centos`

Provides base OS, patches and stable nginx for quick and easy spinup.

[S6](https://github.com/just-containers/s6-overlay) process supervisor is used for `only` for zombie reaping (as PID 1), boot coordination, and termination signal translation  

[Goss](https://github.com/aelsabbahy/goss) is used for build-time testing.  

See parent(s) [docker-base](https://github.com/behance/docker-base) for additional configuration  


### Expectations

- Applications must copy their html/app into the `/var/www/html` folder
- Any new script/file that needs to be added must be given proper permissions/ownership to the non root user through `container/root/scripts/set_permissions.sh`. This is to ensure that the image can be run under a non root user.
-   NOTE: Nginx is exposed and bound to an unprivileged port, `8080`


### Security

See parent [configuration](https://github.com/behance/docker-base#security)


### Environment Variables

Variable | Example | Description
--- | --- | ---
SERVER_MAX_BODY_SIZE | SERVER_MAX_BODY_SIZE=4M | Allows the downstream application to specify a non-default `client_max_body_size` configuration for the `server`-level directive in `/etc/nginx/sites-available/default`
SERVER_INDEX | SERVER_INDEX index.html index.html index.php | Changes the default pages to hit for folder and web roots
SERVER_APP_NAME | SERVER_APP_NAME='view' | Gets appended to the default logging format
SERVER_GZIP_OPTIONS | SERVER_GZIP_OPTIONS=1 | Allows default set of static content to be served gzipped
SERVER_SENDFILE | SERVER_SENDFILE=off | Allows runtime to specify value of nginx's `sendfile` (default, on)
SERVER_KEEPALIVE | SERVER_KEEPALIVE=30 | Define HTTP 1.1's keepalive timeout
SERVER_WORKER_PROCESSES | SERVER_WORKER_PROCESSES=4 | Set to the number of cores in the machine, or the number of cores allocated to container
SERVER_WORKER_CONNECTIONS | SERVER_WORKER_CONNECTIONS=2048 | Sets up the number of connections for worker processes
SERVER_CLIENT_HEADER_BUFFER_SIZE | SERVER_CLIENT_HEADER_BUFFER_SIZE=16k | [docs](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_header_buffer_size)
SERVER_LARGE_CLIENT_HEADER_BUFFERS | SERVER_LARGE_CLIENT_HEADER_BUFFERS=8 16k | [docs](http://nginx.org/en/docs/http/ngx_http_core_module.html#large_client_header_buffers)
SERVER_CLIENT_BODY_BUFFER_SIZE | SERVER_CLIENT_BODY_BUFFER_SIZE=128k | [docs](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_buffer_size)
SERVER_LOG_MINIMAL | SERVER_LOG_MINIMAL=1 | Minimize the logging format, appropriate for development environments
S6_KILL_FINISH_MAXTIME | S6_KILL_FINISH_MAXTIME=55000 | The maximum time (in ms) a script in /etc/cont-finish.d could take before sending a KILL signal to it. Take into account that this parameter will be used per each script execution, it's not a max time for the whole set of scripts. This value has a max of 65535 on Alpine variants.
S6_KILL_GRACETIME | S6_KILL_GRACETIME=500 | Wait time (in ms) for S6 finish scripts before sending kill signal


### Startup/Runtime Modification

- Environment variables are used to drive nginx configuration at runtime
- See [here](https://github.com/behance/docker-base#startupruntime-modification) for more advanced options

### Shutdown Behavior

Graceful shutdown is handled as part of the [existing](https://github.com/behance/docker-base#shutdown-behavior) S6 termination process, using a `/etc/cont-finish.d` script.
Nginx will attempt to drain active workers, while rejecting new connections. The drain timeout is controlled by `S6_KILL_FINISH_MAXTIME`, which corresponds to the length of time the supervisor will wait for the script to run during shutdown. This value defaults to 55s, which deliberately `less` than an downstream load balancers default max connection length (60s). Each upstream's timeout must be less than the downstream, for sanity and lack of timing precision.

### Long-running processes (workers + crons)

- See parent [configuration](https://github.com/behance/docker-base#long-running-processes-workers--crons) on reusing container for other purposes.


### Container Organization

Besides the instructions contained in the Dockerfile, the majority of this
container's use is in configuration and process. The `./container/root` repo directory is overlayed into a container during build. Adding additional files
to the folders in there will be present in the final image.

Nginx is currently set up as an S6 service in `/etc/services-available/nginx`, during default environment conditions, it will symlink itself to be supervised under `/etc/services.d/nginx`. When running under worker entrypoint (`worker.sh`), it will not be S6's `service.d` folder to be supervised.
