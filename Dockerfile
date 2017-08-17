FROM ruby:2.3.0

RUN apt-get update && apt-get install -y \
  build-essential libpq-dev nodejs npm mysql-client git default-jdk

RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN groupadd -r nonadmin && useradd --no-log-init -r -g nonadmin nonadmin

RUN mkdir -p /home/nonadmin
RUN chown -R nonadmin:nonadmin /home/nonadmin

USER nonadmin

WORKDIR /home/nonadmin

RUN git clone -b paperclip_version https://github.com/TeamDiverst/simple_form_fancy_uploads.git

RUN mkdir -p diverst

WORKDIR /home/nonadmin/diverst

COPY Gemfile Gemfile

RUN gem install bundler
RUN bundle install --jobs 20 --retry 5
RUN bundle config local.simple_form_fancy_uploads ../simple_form_fancy_uploads

COPY . .

USER root
RUN chown -R nonadmin:nonadmin .
RUN npm install -g phantomjs

USER nonadmin
RUN npm install
RUN rake bower:install

EXPOSE 3000

CMD rails server -b 0.0.0.0
