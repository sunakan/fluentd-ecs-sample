#!/bin/bash

set -ex

# nginx.conf doesn't support environment variables,
# so we substitute at run time
/bin/sed \
  -e "s/<NGINX_PORT>/${NGINX_PORT:-80}/g" \
  -e "s/<NGINX_LOCATION>/${NGINX_LOCATION}/g" \
  -e "s/<APP_HOST>/${APP_HOST:-app}/g" \
  -e "s/<APP_PORT>/${APP_PORT}/g" \
  -e "s/<CLIENT_BODY_BUFFER_SIZE>/${CLIENT_BODY_BUFFER_SIZE:-8k}/g" \
  -e "s/<CLIENT_MAX_BODY_SIZE>/${CLIENT_MAX_BODY_SIZE:-1M}/g" \
  /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Wait for the application to start before accepting ALB requests.
while sleep 2; do
  curl --verbose --fail --max-time 5 "http://${APP_HOST:-app}:${APP_PORT}${HEALTHCHECK_PATH:-/health_check}" && break
done

# run in foreground as pid 1
exec /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf
