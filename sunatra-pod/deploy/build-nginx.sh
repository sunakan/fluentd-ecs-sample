#!/bin/bash

set -u
set -e

docker build ../nginx-sidecar/ \
  --tag ${DOCKER_NGINX_REPOSITORY}:latest \
  --build-arg DOCKER_NGINX_TAG=${DOCKER_NGINX_TAG}
docker tag ${DOCKER_NGINX_REPOSITORY}:latest ${DOCKER_NGINX_REPOSITORY}:${DOCKER_NGINX_TAG}

echo "${DOCKER_NGINX_REPOSITORY}:${DOCKER_NGINX_TAG}"
