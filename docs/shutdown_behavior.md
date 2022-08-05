# Shutdown Behavior

Graceful shutdown is handled as part of the [existing](https://github.com/behance/docker-base#shutdown-behavior) S6 termination process, using a `/etc/cont-finish.d` script.
Nginx will attempt to drain active workers, while rejecting new connections. The drain timeout is controlled by `S6_KILL_FINISH_MAXTIME`, which corresponds to the length of time the supervisor will wait for the script to run during shutdown. This value defaults to 55s, which deliberately `less` than an downstream load balancers default max connection length (60s). Each upstream's timeout must be less than the downstream, for sanity and lack of timing precision.

