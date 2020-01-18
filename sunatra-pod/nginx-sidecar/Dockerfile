ARG DOCKER_NGINX_TAG
FROM nginx:${DOCKER_NGINX_TAG}

RUN apt update && apt install -y curl

COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY start.sh /usr/bin/start.sh
RUN chmod a+x /usr/bin/start.sh

CMD /usr/bin/start.sh
