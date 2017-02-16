# docker-nginx

https://hub.docker.com/r/behance/docker-nginx/tags/

Ubuntu used by default, Alpine builds also available tagged as `-alpine`


Provides base OS, patches and stable nginx for quick and easy spinup.

[S6](https://github.com/just-containers/s6-overlay) process supervisor is used for `only` for zombie reaping (as PID 1), boot coordination, and termination signal translation

[Goss](https://github.com/aelsabbahy/goss) is used for build-time testing.

See parent(s) [docker-base](https://github.com/behance/docker-base) for additional configuration


### Expectations

Applications using this as a container parent must copy their html/app into the `/var/www/html` folder
NOTE: Nginx is exposed and bound to an unprivileged port, `8080`


### Security

For Ubuntu-based variants, a convenience script is provided for security-only package updates. To run: `/bin/bash -e /security_updates.sh`

### Environment Variables

Variable | Example | Description
--- | --- | ---
`SERVER_MAX_BODY_SIZE` | `SERVER_MAX_BODY_SIZE=4M` | Allows the downstream application to specify a non-default `client_max_body_size` configuration for the `server`-level directive in `/etc/nginx/sites-available/default`
`SERVER_INDEX` | `SERVER_INDEX index.html index.html index.php` | Changes the default pages to hit for folder and web roots
`SERVER_APP_NAME` | `SERVER_APP_NAME='view'` | Gets appended to the default logging format
`SERVER_GZIP_OPTIONS` | `SERVER_GZIP_OPTIONS=1` | Allows default set of static content to be served gzipped
`SERVER_SENDFILE` | `SERVER_SENDFILE=off` | Allows runtime to specify value of nginx's `sendfile` (default, on)
`SERVER_KEEPALIVE` | `SERVER_KEEPALIVE=30` | Define HTTP 1.1's keepalive timeout
`SERVER_WORKER_PROCESSES` | `SERVER_WORKER_PROCESSES=4` | Set to the number of cores in the machine, or the number of cores allocated to container
`SERVER_WORKER_CONNECTIONS` | `SERVER_WORKER_CONNECTIONS=2048` | Sets up the number of connections for worker processes
`SERVER_CLIENT_HEADER_BUFFER_SIZE` | `SERVER_CLIENT_HEADER_BUFFER_SIZE=16k | [docs](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_header_buffer_size)
`SERVER_LARGE_CLIENT_HEADER_BUFFERS` | `SERVER_LARGE_CLIENT_HEADER_BUFFERS=8 16k` | [docs](http://nginx.org/en/docs/http/ngx_http_core_module.html#large_client_header_buffers)
`SERVER_CLIENT_BODY_BUFFER_SIZE` | `SERVER_CLIENT_BODY_BUFFER_SIZE=128k` | [docs](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_buffer_size)
`SERVER_LOG_MINIMAL` | `SERVER_LOG_MINIMAL=1` | Minimize the logging format, appropriate for development environments
`S6_KILL_FINISH_MAXTIME` | `S6_KILL_FINISH_MAXTIME=1000` | Wait time (in ms) for zombie reaping before sending a kill signal
`S6_KILL_GRACETIME` | `S6_KILL_GRACETIME=500` | Wait time (in ms) for S6 finish scripts before sending kill signal
`SERVER_ENABLE_SSL` | `SERVER_ENABLE_SSL=` | Enable SSL directives in default configuration


### Startup/Runtime Modification

To inject changes just before runtime, shell scripts (ending in .sh) may be placed into the
`/etc/cont-init.d` folder. For example, the above environment variables are used to drive nginx configuration at runtime.
As part of the process manager, these scripts are run in advance of the supervised processes. @see https://github.com/just-containers/s6-overlay#executing-initialization-andor-finalization-tasks

### HTTPS/SSL support for local development

Follow these steps to create an image and run a container that hosts a static website or a service using nginx.

* On your development machine, download or generate an x509 certificate and key appropriate for use with apache or nginx. Install these with the names certificate.crt and certificate.key, respectively, in a local folder.
* Add an entry to your /etc/hosts to map 127.0.0.1 to the server host name corresponding to your certificate.
* Run the image using --env SERVER_ENABLE_SSL=true
* Start a container using:
  * -v {folder-containing-certificate.crt/key}:/etc/nginx/certs:ro
  * -p 443:8080 (or whatever host port you are using)
* Test
  * curl https://{your-server-hostname}, or,
  * curl -k https://localhost

### Advanced Modification

More advanced changes can take effect using the run.d system. Similar to the `/etc/cont-init.d/` script system, any scripts (ending in .sh) in the `/run.d/` folder will be executed ahead of the S6 initialization.

- If run.d script terminates with a non-zero exit code, container will stop, terminating with the script's exit code, unless...
- If script terminates with exit code of $SIGNAL_BUILD_STOP (99), this will signal the container to stop cleanly. This can be used for multi-stage builds


### Long-running processes (workers + crons)

This container image can be shared between web and non-web processes. An example use case would be
a web service and codebase that also has a few crons and background workers. To reuse this container for
those types of workloads:

`docker run {image_id} /worker.sh 3 /bin/binary -parameters -that -binary -receives`

Runs `3` copies of `/bin/binary` that receives the parameters `-parameters -that -binary -receives`


### Container Organization

Besides the instructions contained in the Dockerfile, the majority of this
container's use is in configuration and process. The `./container/root` repo directory is overlayed into a container during build. Adding additional files
to the folders in there will be present in the final image.

Nginx is currently set up as an S6 service in `/etc/services-available/nginx`, during default environment conditions, it will symlink itself to be supervised under `/etc/services.d/nginx`. When running under worker entrypoint (`worker.sh`), it will not be S6's `service.d` folder to be supervised.
