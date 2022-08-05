.PHONY: build

# Name of the image to build
IMAGE_TAG=docker-nginx:njs

default: build

build-src:
	cd ../.. && docker build -t $(IMAGE_TAG) -f Dockerfile-ubuntu-22.04 .

build: build-src
	docker build -t $(IMAGE_TAG)-test -f Dockerfile .

dgoss: build
	GOSS_WAIT_OPTS="-r 60s -s 5s > /dev/null" dgoss run -e SERVER_ENABLE_NGX_HTTP_JS=true -p 8080:8080 $(IMAGE_TAG)-test

