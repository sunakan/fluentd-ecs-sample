#!/bin/bash

set -u
set -e

docker build ../sunatra/ \
  --tag ${DOCKER_SUNATRA_REPOSITORY}:${DOCKER_RUBY_TAG} \
  --build-arg DOCKER_RUBY_TAG=${DOCKER_RUBY_TAG}

echo "${DOCKER_SUNATRA_REPOSITORY}:${DOCKER_RUBY_TAG}"
