FROM ruby:2.3.0

RUN apt-get update && apt-get install -y \
  build-essential libpq-dev nodejs npm mysql-client

RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN mkdir -p /diverst

WORKDIR /diverst

COPY Gemfile Gemfile

RUN gem install bundler && bundle install --jobs 20 --retry 5

COPY . .

RUN npm install
RUN rake bower:install['--allow-root']

EXPOSE 3000

ENTRYPOINT ["bundle", "exec"]

CMD ["rails", "server", "-b", "0.0.0.0"]
