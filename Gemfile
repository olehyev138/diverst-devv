source 'https://rubygems.org'

ruby '2.6.5'

gem 'active_storage_validations', '~> 0.8.4'
gem 'mini_magick', '~> 4.10.1'
gem 'actionmailer', '~> 5.2.3'
gem 'actionpack', '~> 5.2.3'
gem 'active_model_serializers', '~> 0.10.10'
gem 'active_record_union'
gem 'activerecord', '~> 5.2.3'
gem 'activerecord-import', '~> 0.14.0' # Adds a faster way to INSERT multiple rows in the DB
gem 'autoprefixer-rails', '~> 6.3', '>= 6.3.3.1' # Automatically adds vendor prefixes to CSS declarations
gem 'aws-sdk'
gem 'aws-sdk-s3', require: false
gem 'bcrypt'
gem 'bootsnap', require: false
gem 'clockwork', '~> 1.2' # Schedule recurring jobs
gem 'daemons', '~> 1.2', '>= 1.2.3' # For capistrano-clockwork
gem 'date_validator', '~> 0.9.0'
gem 'elasticsearch-model', '~> 6.0.0'
gem 'elasticsearch-rails', '~> 6.0.0'
gem 'enumerize', '~> 2.0'
gem 'factory_bot_rails', '~> 4.8.0' # Create mock objects for testing
gem 'faker', '~> 1.6'
gem 'fcm', '~> 0.0.6'
gem 'figaro', '~> 1.1', '>= 1.1.1' # Inject ENV from application.yml
gem 'http'
gem 'httparty', '~> 0.13' # HTTP request library
gem 'image_processing', '~> 1.10.1'
gem 'julia_builder', '~> 0.2.0'
gem 'jwt', '~> 2.1.0', require: false
gem 'linkedin-oauth2', '~> 1.0' # OAuth for LinkedIn
gem 'mailgun_rails', '~> 0.8.0'
gem 'mysql2', '~> 0.5.2'
gem 'paperclip', '~> 5.1.0' # TODO Remove after Paperclip to ActiveStorage migration
gem 'public_activity'
gem 'puma', '~> 3.1' # Better web server than WEBRick
gem 'pundit', '~> 2.0.0'# Authorization
gem 'rack-cors', '~> 0.4.0', require: 'rack/cors' # will be used to support mobile
gem 'rack-rewrite', '~> 1.5' # A rack middleware for enforcing rewrite rules. In many cases you can get away with rack-rewrite instead of writing Apache mod_rewrite rules.
gem 'rack-timeout', '~> 0.4.2'
gem 'rails', '~> 5.2.3'
gem 'railties', '~> 5.2.3'
gem 'rollbar', '~> 2.14.1'
gem 'rqrcode', '~> 0.10.1', require: false
gem 'ruby-oembed', '~> 0.12'
gem 'ruby-saml', '>= 1.7.0'
gem 'sanitize_email', '~> 1.2.2'
gem 'sidekiq', '~> 6.0.4' # Background jobs
gem 'thor', '0.20.0' # Expected string default value for '--decorator'; got true (boolean) - setting version removes this message
gem 'tty-spinner'
gem 'twilio-ruby', '~> 5.10.0'
gem 'twitter', '~> 6.2.0' # twitter implementation
gem 'validate_url', '~> 1.0', '>= 1.0.2' # Active Model validation for URLs
gem 'yam', '~> 2.5' # Yammer ruby SDK
gem 'seedbank', '~> 0.3.0' # Support for multiple seed files and their ordering

# gem 'omniauth-linkedin-oauth2', '~> 0.1.5' # OAuth for LinkedIn
# gem 'omniauth-oauth2', '1.3.1' # Temporary fix to address: https://github.com/decioferreira/omniauth-linkedin-oauth2/issues/28

group :development, :test do
  # The 3 gems above are for livereloading your code
  gem 'byebug', '~> 9.1.0' # Debugger
  gem 'pronto', '~> 0.10.0'
  gem 'database_cleaner', '~> 1.6.1' # Necessary to clean the DB between tests
  gem 'pronto-eslint_npm', git: 'https://github.com/doits/pronto-eslint_npm.git'
  gem 'pronto-rubocop', '~> 0.10.0'
  gem 'pundit-matchers', '~> 1.6.0'
  gem 'rspec-rails' # Testing framework
  gem 'rubocop', '~> 0.68.1'
  gem 'rubocop-performance', '~> 1.2.0'
  gem 'shoulda-matchers', '4.0.1'
  gem 'timecop', '~> 0.8.1'
  gem 'clipboard', '~> 1.3', '>= 1.3.3'
  gem 'awesome_print', '~> 1.8'
  gem 'active_record_query_trace', '>= 1.7'
  gem 'yard', '~> 0.8.7.6'
end

group :test do
  gem 'clockwork-test', '~> 0.2.0'
  gem 'hashdiff', '1.0.0'
  gem 'rspec_junit_formatter', '~> 0.2.3'
  gem 'simplecov', '~> 0.13.0'
  gem 'webmock', '~> 3.7.6'
end

group :development do
  gem 'bcrypt_pbkdf', '~> 1.0.1'
  gem 'bullet'
  gem 'capistrano', '~> 3.9.1', require: false
  gem 'capistrano-bower', '~> 1.1.0'
  gem 'capistrano-bundler', '~> 1.3.0', require: false
  gem 'capistrano-clockwork', '~> 1.0.1'
  gem 'capistrano-locally', '~> 0.2.6', require: false
  gem 'capistrano-npm', '~> 1.0.3'
  gem 'capistrano-rails', '~> 1.3.0', require: false
  gem 'capistrano-rails-console', '~> 2.2.1'
  gem 'capistrano-rake', '~> 0.2.0', require: false
  gem 'capistrano-rvm', '~> 0.1.2'
  gem 'capistrano-sidekiq', '~> 0.5.4'
  gem 'capistrano3-puma', '~> 3.1.1'
  gem 'ed25519', '~> 1.2.4'
  gem 'rufo', '~> 0.1.0'
end

group :staging, :production do
  gem 'influxdb-rails'
  gem 'lograge', '~> 0.3'
  gem 'sidekiq-influxdb', '~> 1.1.0' # Sidekiq metrics to InfluxDB
  gem 'syslogger', '~> 1.6.0' # Log to syslog, which is then sent to Loggly
end
