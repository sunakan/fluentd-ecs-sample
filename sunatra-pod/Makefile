export FLUENTD_PORT=24225
export SINATRA_PORT=4568
export NGINX_PORT=8080
export POD_LOG_PREFIX=s3-clone
config:
	docker-compose config
up:
	docker-compose up
down:
	docker-compose down
curl:
	curl http://127.0.0.1:${NGINX_PORT}/suna-app/sunatra && sleep 1
	curl http://127.0.0.1:${NGINX_PORT}/suna-app/sunatra && sleep 1
	curl http://127.0.0.1:${NGINX_PORT}/suna-app/sunatra

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
