# docker-nginx

Provides base OS, patches and stable nginx for quick and easy spinup.

https://hub.docker.com/r/behance/docker-nginx/tags/

| OS     | Version  | Nginx Package | Tag            |
| ------ | -------- | ------------- | -------------- |
| ubuntu | 20.04    | nginx-light   | None           |
| ubuntu | 22.04    | nginx         | `-ubuntu-22.04 |

The following builds are **DEPRECATED** and will be removed in a future release

- Alpine builds available tagged as `-alpine` **DEPRECATED**
- Centos builds available tagged as `-centos` **DEPRECATED**

| Module      | ubuntu-20.04   | ubuntu-22.04    |
| ----------- | -------------- | --------------- |
| brotli      | &check;        | n/a             |
| njs         | n/a            | n/a             |

[S6](https://github.com/just-containers/s6-overlay) process supervisor is used
for `only` for zombie reaping (as PID 1), boot coordination, and termination
signal translation

[Goss](https://github.com/aelsabbahy/goss) is used for build-time testing.

See parent(s) [docker-base](https://github.com/behance/docker-base) for
additional configuration

# Expectations

NOTE: Nginx is exposed and bound to an unprivileged port, `8080`

* Applications must copy their html/app into the `/var/www/html` folder

* Any new script/file that needs to be added must be given proper permissions /
ownership to the non root user through `container/root/scripts/set_permissions.sh`.
This is to ensure that the image can be run under a non root user.

# Quick Start

See [Quick Start](docs/quick_start.md)

# Docs

* [Container Organization](docs/container_organization.md)
* [Container Security](docs/container_security.md)
* [Environment Variables](docs/env_vars.md)
* [Long-running processes (workers + crons)](docs/long_running.md)
* [Shutdown Behavior](docs/shutdown_behavior.md)
* [Release Management](docs/release_management.md)
* [Troubleshooting](docs/troubleshooting.md)
