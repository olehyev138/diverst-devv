FROM ruby:2.3.0

RUN apt-get update && apt-get install -y \
  build-essential libpq-dev nodejs npm mysql-client git

RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN git clone -b paperclip_version https://github.com/TeamDiverst/simple_form_fancy_uploads.git

RUN mkdir -p /diverst

WORKDIR /diverst

COPY Gemfile Gemfile

RUN gem install bundler && bundle install --jobs 20 --retry 5
RUN bundle config local.simple_form_fancy_uploads /simple_form_fancy_uploads

COPY . .

RUN npm install
RUN rake bower:install['--allow-root']

EXPOSE 3000

CMD rails server -b 0.0.0.0
