source 'https://rubygems.org'

ruby '2.2.3'

gem 'rails', '4.2.1'
gem 'mysql2', '~> 0.3.18'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'sdoc', '~> 0.4.0', group: :doc # bundle exec rake doc:rails generates the API under doc/api.

gem 'puma'
gem 'figaro'
gem 'devise'
gem 'devise_invitable'
gem 'simple_form'
gem 'cocoon'
gem 'ruby-saml', '~> 1.0.0'
gem 'sidekiq', '< 5'
gem 'devise-async'
gem 'sinatra', :require => nil # Required for sidekiq's dashboard
gem 'newrelic_rpm'
gem 'seedbank'
gem 'rails-patch-json-encode'
gem 'oj'
gem 'faker'
gem 'active_model_serializers'
gem 'devise_token_auth'
gem 'firebase_token_generator'
gem 'firebase'
gem 'houston'
gem 'bower-rails', '~> 0.10.0'
gem 'gcm'
gem 'clockwork'
gem 'bourbon'
gem 'pismo'
gem 'active_link_to'
gem 'paperclip', '~> 4.3'
gem 'aws-sdk', '< 2.0'
gem 'kaminari'
gem 'jquery-datatables-rails'
gem 'ajax-datatables-rails'
gem 'elasticsearch-model', '~> 0.1'
gem 'elasticsearch-rails', '~> 0.1'
gem 'sprockets', '>= 3.0.0'
gem 'sprockets-es6'
gem 'awesome_print'
gem 'yam'
gem 'httparty', '~> 0.13'
gem 'appsignal', '~> 0.12.rc'
gem 'syslogger', '~> 1.6.0'
gem 'lograge', '~> 0.3.1'

group :development, :test do
  gem 'spring' # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'guard-livereload', '~> 2.4', require: false
  gem 'rb-readline'
  gem 'rack-livereload'
  gem 'quiet_assets'
  gem 'active_record_query_trace'
  gem 'rspec-rails', '~> 3.0'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
  # gem 'pry-rails'
end

gem 'rspec_junit_formatter', '0.2.2', group: :test

gem "parallel_tests", group: :development

group :development do
  gem 'capistrano'
  gem 'capistrano3-puma'
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rvm'
  gem 'capistrano-bower'
  gem 'capistrano-rails-console'
  gem 'capistrano-sidekiq'
  gem 'spring-commands-rspec'
end