#!/bin/bash

set -u
set -e

docker build ../fluentd-sidecar/ \
  --tag ${DOCKER_FLUENTD_REPOSITORY}:latest \
  --build-arg DOCKER_FLUENTD_TAG=${DOCKER_FLUENTD_TAG}
docker tag ${DOCKER_FLUENTD_REPOSITORY}:latest ${DOCKER_FLUENTD_REPOSITORY}:${DOCKER_FLUENTD_TAG}

echo "${DOCKER_FLUENTD_REPOSITORY}:${DOCKER_FLUENTD_TAG}"
