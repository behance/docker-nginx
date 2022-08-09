# Quick Start

1. Fork and clone the git repo
1. cd into `docker-nginx` and run `make`
    ```
    make

    # Or if you're on an ARM machine i.e. M1, do
    VERSION=arm64 PLATFORM=linux/arm64 make
    ```
1. Wait for the build to complete
1. Once the build completes, start up the image as:
    ```
    docker run -it -e SERVER_APP_NAME=hello -p 8080:8080 docker-nginx
    ```
1. Curl your endpoint
    ```
    curl http://127.0.0.1:8080/
    ```
