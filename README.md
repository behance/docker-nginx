# docker-nginx
Provides base OS, patches and stable nginx for quick and easy spinup


Environment Variable | Example | Description
--- | --- | ---
`SERVER_MAX_BODY_SIZE` | `SERVER_MAX_BODY_SIZE=4M` | Allows the downstream application to specify a non-default `client_max_body_size` configuration for the `server`-level directive in `/etc/nginx/sites-available/default`
`SERVER_INDEX` | `SERVER_INDEX index.html index.html index.php` | Changes the default pages to hit for folder and web roots
`SERVER_APP_NAME` | `SERVER_APP_NAME='view'` | Sets a kv pair to be consumed by logging service for easy parsing and searching
`SERVER_GZIP_OPTIONS` | `SERVER_GZIP_OPTIONS=1` | Allows default set of static content to be served gzipped
`SERVER_SENDFILE` | `SERVER_SENDFILE=off` | Allows runtime to specify value of nginx's `sendfile` (default, on)

### Build Arguments
---
In docker 1.9+, `--build-arg=` can be used to inject variables into the build environment. The arguments are available:

Build Variable | Example | Description
--- | --- | ---
`APT_SOURCE` | `--build-arg APT_SOURCE=cache.apt.local` | Injects a local apt-mirror to be used to retrieve packages


### Runtime Commands

To inject things into the runtime process, add shell scripts (ending in .sh) into the
`/run.d` folder. These will be executed during container start.

- If script terminates with a non-zero exit code, container will stop, terminating with the script's exit code, unless...
- If script terminates with exit code of $SIGNAL_BUILD_STOP (99), this will signal the container to stop cleanly. This can be used for multi-stage builds that can be committed


### Long-running processes (workers)

`docker run {image_id} /worker.sh 3 /bin/binary -parameters -that -binary -receives`

Runs 3 copies of `/bin/binary` that receives any arguments as parameters
