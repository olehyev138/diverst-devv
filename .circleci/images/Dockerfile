FROM ruby:2.6.5-buster

RUN apt-get update && apt-get install -y \
  build-essential \
  mariadb-server \
  mariadb-client \
  nodejs \
  git \
  cmake \
  libglu1 \
  --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN gem install bundler

RUN apt-get remove -y nodejs
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash - && apt-get install -y nodejs

ENV DB_DATA_PATH "/var/lib/mysql"
ENV DB_ROOT_PASS "mariadb_root_password"
ENV DB_USER "mariadb_user"
ENV DB_PASS "mariadb_user_password"
ENV MAX_ALLOWED_PACKET "200M"
RUN mysql_install_db --user=mysql --datadir=${DB_DATA_PATH}

LABEL com.circleci.preserve-entrypoint=true
ENTRYPOINT ["mysqld_safe"]
