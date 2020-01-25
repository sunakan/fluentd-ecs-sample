DOCKER_FLUENTD_TAG=v1.8-1
build:
	docker build ./ \
    --tag sunakan/s3-fluentd \
    --build-arg DOCKER_FLUENTD_TAG=${DOCKER_FLUENTD_TAG}

up:
	docker-compose up
ash: s3-clone
	docker-compose run --rm fluentd ash
exec-ash:
	docker exec -it -u root `docker-compose ps --quiet fluentd` --workdir /fluentd ash
down:
	docker-compose down
prune:
	docker container prune
clean:
	rm -rf s3-clone/*

s3-clone:
	mkdir s3-clone
