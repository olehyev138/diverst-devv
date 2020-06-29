FROM ruby:2.6.6-buster

# Install base packages
RUN apt-get update && apt-get install -y \
  build-essential \
  git \
  cmake \
  libglu1 \
  curl \
  awscli \
  --no-install-recommends && rm -rf /var/lib/apt/lists/*

# Install chamber (secrets management)
RUN curl -s https://packagecloud.io/install/repositories/segment/chamber/script.deb.sh | bash
RUN apt-get install -y chamber

# Install latest nodejs, remove any existing version
RUN apt-get remove -y nodejs
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash - && apt-get install -y nodejs

RUN gem install bundler

LABEL com.circleci.preserve-entrypoint=true
ENTRYPOINT ["irb"]
