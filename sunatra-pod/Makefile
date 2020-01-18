up:
	docker-compose up
down:
	docker-compose down
curl:
	curl http://127.0.0.1/suna-app/sunatra && sleep 1
	curl http://127.0.0.1/suna-app/sunatra && sleep 1
	curl http://127.0.0.1/suna-app/sunatra

build-sunatra:
	cd deploy && make build-sunatra
build-nginx:
	cd deploy && make build-nginx
build-fluentd:
	cd deploy && make build-fluentd
build:
	make build-sunatra
	make build-nginx
	make build-fluentd
