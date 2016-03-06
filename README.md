# docker-nginx
Provides base OS, patches and stable nginx for quick and easy spinup.
Integrates S6 process supervisor for zombie reaping (as PID 1) and boot coordination.
@see https://github.com/just-containers/s6-overlay

### Expectations

Applications using this as a container parent must copy their html/app into the `/var/www/html` folder



### Environment Variables

Variable | Example | Description
--- | --- | ---
`SERVER_MAX_BODY_SIZE` | `SERVER_MAX_BODY_SIZE=4M` | Allows the downstream application to specify a non-default `client_max_body_size` configuration for the `server`-level directive in `/etc/nginx/sites-available/default`
`SERVER_INDEX` | `SERVER_INDEX index.html index.html index.php` | Changes the default pages to hit for folder and web roots
`SERVER_APP_NAME` | `SERVER_APP_NAME='view'` | Gets appended to the default logging format
`SERVER_GZIP_OPTIONS` | `SERVER_GZIP_OPTIONS=1` | Allows default set of static content to be served gzipped
`SERVER_SENDFILE` | `SERVER_SENDFILE=off` | Allows runtime to specify value of nginx's `sendfile` (default, on)
`SERVER_KEEPALIVE` | `SERVER_KEEPALIVE=30` | Define HTTP 1.1's keepalive timeout
`SERVER_WORKER_CONNECTIONS` | `SERVER_WORKER_CONNECTIONS=2048` | Sets up the number of connections for worker processes
`SERVER_LOG_MINIMAL` | `SERVER_LOG_MINIMAL=1` | Minimize the logging format, appropriate for development environments
`S6_KILL_FINISH_MAXTIME` | `S6_KILL_FINISH_MAXTIME=1000` | Wait time (in ms) for zombie reaping before sending a kill signal
`S6_KILL_GRACETIME` | `S6_KILL_GRACETIME=500` | Wait time (in ms) for S6 finish scripts before sending kill signal


### Startup/Runtime Modification

To inject changes just before runtime, shell scripts (ending in .sh) may be placed into the
`/etc/cont-init.d` folder. For example, the above environment variables are used to drive nginx configuration at runtime.
As part of the process manager, these scripts are run in advance of the supervised processes. @see https://github.com/just-containers/s6-overlay#executing-initialization-andor-finalization-tasks


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
