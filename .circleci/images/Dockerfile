FROM ruby:2.6.5-buster

RUN apt-get update && apt-get install -y \
  build-essential \
  nodejs \
  git \
  cmake \
  libglu1 \
  awscli \
  --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN gem install bundler

RUN apt-get remove -y nodejs
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash - && apt-get install -y nodejs

LABEL com.circleci.preserve-entrypoint=true
ENTRYPOINT ["irb"]
