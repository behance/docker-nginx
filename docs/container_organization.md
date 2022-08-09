# Container Organization

Besides the instructions contained in the Dockerfile, the majority of this
container's use is in configuration and process. The `./container/root` repo directory is overlayed into a container during build. Adding additional files
to the folders in there will be present in the final image.

Nginx is currently set up as an S6 service in `/etc/services-available/nginx`, during default environment conditions, it will symlink itself to be supervised under `/etc/services.d/nginx`. When running under worker entrypoint (`worker.sh`), it will not be S6's `service.d` folder to be supervised.