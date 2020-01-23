export DOCKER_FLUENTD_REPOSITORY=sunakan/suna-fluentd
export DOCKER_FLUENTD_TAG=v1.8-1
build:
	docker build ./ \
		--tag ${DOCKER_FLUENTD_REPOSITORY}:${DOCKER_FLUENTD_TAG} \
    --build-arg DOCKER_FLUENTD_TAG=${DOCKER_FLUENTD_TAG}

up:
	docker-compose up
down:
	docker-compose down
check:
	curl http://127.0.0.1/
