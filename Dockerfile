FROM ruby:2.6

ENV APP_DIR /webapp
RUN mkdir $APP_DIR

RUN apt-get update && apt-get install -y build-essential cmake mariadb-client nodejs git --no-install-recommends && rm -rf /var/lib/apt/lists/*

ENV RAILS_LOG_TO_STDOUT true

COPY Gemfile Gemfile.lock $APP_DIR/

WORKDIR $APP_DIR

ENV BUNDLER_VERSION='2.0.2'
RUN gem install bundler -v '2.0.2'
RUN bundler install

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
