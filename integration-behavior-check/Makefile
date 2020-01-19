s3-clone:
	mkdir -p ./s3-clone && rm -rf ./s3-clone/*

minio: s3-clone
	docker-compose \
    -f ./docker-compose.minio.yml \
    -f ./docker-compose.network.yml \
    -p s3-clone-pod-101 \
    up
clean:
	rm -rf ./s3-clone/sunacket/*

aggregation-1:
	export AGGREGATION_FLUENTD_HOST=aggregation-fluentd \
  && export AGGREGATION_FLUENTD_PORT=24224 \
  && docker-compose \
    -f ./docker-compose.aggregation-fluentd.yml \
    -f ./docker-compose.network.yml \
    -p aggregation-fluentd-pod-101 \
    up

pod-1:
	export AGGREGATION_FLUENTD_HOST=aggregation-fluentd \
  && export AGGREGATION_FLUENTD_PORT=24224 \
  && export POD_LOG_PREFIX=s3-clone \
  && export POD_NUMBER=101 \
  && export FLUENTD_PORT=24225 \
  && export SINATRA_PORT=4567 \
  && export NGINX_PORT=8080 \
  && docker-compose \
    -f ./docker-compose.sunatra-pod.yml \
    -f ./docker-compose.network.yml \
    -p sunatra-pod-101 \
    up
pod-2:
	export AGGREGATION_FLUENTD_HOST=aggregation-fluentd \
  && export AGGREGATION_FLUENTD_PORT=24224 \
  && export POD_LOG_PREFIX=s3-clone \
  && export POD_NUMBER=202 \
  && export FLUENTD_PORT=24226 \
  && export SINATRA_PORT=4568 \
  && export NGINX_PORT=8081 \
  && docker-compose \
    -f ./docker-compose.sunatra-pod.yml \
    -f ./docker-compose.network.yml \
    -p sunatra-pod-202 \
    up
check:
	curl http://127.0.0.1:8081/suna-app/sunatra
	curl http://127.0.0.1:8080/suna-app/sunatra
down-pod-1:
	export AGGREGATION_FLUENTD_HOST=aggregation-fluentd \
  && export AGGREGATION_FLUENTD_PORT=24224 \
  && export POD_LOG_PREFIX=s3-clone \
  && export POD_NUMBER=101 \
  && export FLUENTD_PORT=24225 \
  && export SINATRA_PORT=4567 \
  && export NGINX_PORT=8080 \
  && docker-compose \
    -f ./docker-compose.sunatra-pod.yml \
    -f ./docker-compose.network.yml \
    -p sunatra-pod-101 \
    down
down-pod-2:
	export AGGREGATION_FLUENTD_HOST=aggregation-fluentd \
  && export AGGREGATION_FLUENTD_PORT=24224 \
  && export POD_LOG_PREFIX=s3-clone \
  && export POD_NUMBER=202 \
  && export FLUENTD_PORT=24226 \
  && export SINATRA_PORT=4568 \
  && export NGINX_PORT=8081 \
  && docker-compose \
    -f ./docker-compose.sunatra-pod.yml \
    -f ./docker-compose.network.yml \
    -p sunatra-pod-202 \
    down
