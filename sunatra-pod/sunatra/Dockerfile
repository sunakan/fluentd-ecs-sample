ARG DOCKER_RUBY_TAG
FROM ruby:${DOCKER_RUBY_TAG}

ENV APP_ROOT /app
WORKDIR ${APP_ROOT}

COPY Gemfile* ./

RUN bundle install

COPY app.rb ./

CMD ["bash", "-c", "bundle exec ruby ./app.rb -p ${SINATRA_PORT:-4567} -o 0.0.0.0"]
