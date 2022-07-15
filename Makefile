.PHONY: all

IMAGE_NAME ?= docker-nginx
OS_FAMILY ?= ubuntu-22.04
PLATFORM ?= linux/amd64
VERSION ?= test

# Create
IMAGE_TAG ?= $(VERSION)-$(OS_FAMILY)

default: build

build:
	docker build --platform $(PLATFORM) -t $(IMAGE_NAME):$(IMAGE_TAG) -f Dockerfile-$(OS_FAMILY) .

clean-room:
	docker system prune -a -f --volumes
