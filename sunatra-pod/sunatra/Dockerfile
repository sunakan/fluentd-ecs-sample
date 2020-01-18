ARG DOCKER_RUBY_TAG
FROM ruby:${DOCKER_RUBY_TAG}

ENV APP_ROOT /app
WORKDIR ${APP_ROOT}

COPY Gemfile* ./

RUN bundle install

COPY app.rb ./

EXPOSE 4567

CMD ["bundle", "exec", "ruby", "./app.rb", "-o", "0.0.0.0"]
