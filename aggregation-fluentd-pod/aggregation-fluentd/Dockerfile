ARG DOCKER_FLUENTD_TAG
FROM fluentd:${DOCKER_FLUENTD_TAG}

USER root
RUN apk add --no-cache --update --virtual .build-deps tzdata \
  && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
  && apk del .build-deps \
  && rm -rf /var/cache/apk/* \
  && fluent-gem install fluent-plugin-slack fluent-plugin-s3

COPY ./fluent.conf /fluentd/etc/fluent.conf
USER fluent
