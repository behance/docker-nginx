# docker-nginx
Provides base OS, patches and stable nginx for quick and easy spinup


Variable | Example | Description
--- | --- | ---
`SERVER_MAX_BODY_SIZE` | `SERVER_MAX_BODY_SIZE=4M` | Allows the downstream application to specify a non-default `client_max_body_size` configuration for the `server`-level directive in `/etc/nginx/sites-available/default`
`SERVER_INDEX` | `SERVER_INDEX index.html index.html index.php` | Changes the default pages to hit for folder and web roots
