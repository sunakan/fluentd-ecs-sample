up:
	docker-compose up
bash:
	docker-compose run --rm fluentd bash
exec-bash:
	docker exec -it -u root `docker-compose ps --quiet fluentd` bash
down:
	docker-compose down
prune:
	docker container prune
