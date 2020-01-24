FROM ruby:2.4.0

RUN apt-get update && apt-get install -y \
  build-essential libpq-dev nodejs npm mysql-client git default-jdk

RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN groupadd -r nonadmin && useradd --no-log-init -r -g nonadmin nonadmin

RUN mkdir -p /home/nonadmin

WORKDIR /home/nonadmin

RUN git clone -b paperclip_version https://github.com/TeamDiverst/simple_form_fancy_uploads.git

RUN mkdir -p diverst

WORKDIR /home/nonadmin/diverst

COPY Gemfile Gemfile

RUN mkdir -p /home/nonadmin/bundle

RUN gem update --system
RUN gem install bundler
RUN bundle install --jobs 20 --retry 5 --path /home/nonadmin/bundle
RUN bundle config local.simple_form_fancy_uploads /home/nonadmin/simple_form_fancy_uploads

COPY . .

RUN npm install -g phantomjs
RUN npm install
RUN rake bower:install['--allow-root']

EXPOSE 3000

RUN chown -R nonadmin:nonadmin /home/nonadmin

RUN usermod -u 1000 nonadmin
RUN usermod -G staff nonadmin

USER nonadmin

CMD rails server -b 0.0.0.0
