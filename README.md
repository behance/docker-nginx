# docker-nginx
Provides base OS, patches and stable nginx for quick and easy spinup


Variable | Example | Description
--- | --- | ---
`SERVER_MAX_BODY_SIZE` | `SERVER_MAX_BODY_SIZE=4M` | Allows the downstream application to specify a non-default `client_max_body_size` configuration for the `server`-level directive in `/etc/nginx/sites-available/default`
`SERVER_INDEX` | `SERVER_INDEX index.html index.html index.php` | Changes the default pages to hit for folder and web roots
`SERVER_APP_NAME` | `APP_NAME='view'` | Sets a kv pair to be consumed by logging service for easy parsing and searching


### Runtime Commands

To inject things into the runtime process, add shell scripts (ending in .sh) into the
`/run.d` folder. These will be executed during container start.

- If script terminates with a non-zero exit code, container will stop, terminating with the script's exit code, unless...
- If script terminates with exit code of 99, this will signal the container to stop cleanly. This can be used for multi-stage builds that can be committed
