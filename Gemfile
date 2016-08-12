source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', '~> 4.2.7.1'
gem 'mysql2', '~> 0.4.3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'sdoc', '~> 0.4.0', group: :doc # bundle exec rake doc:rails generates the API under doc/api.

gem 'nokogiri', '>= 1.6.8' # need to specify this explicitly, old version has exploit

gem 'puma' # Better web server than WEBRick
gem 'figaro' # Inject ENV from application.yml
gem 'devise' # Authentication
gem 'devise_invitable' # Invite system (admins invite normal users)
gem 'simple_form' # Better forms
gem 'cocoon' # Nested forms (deals with the JS for you)
gem 'ruby-saml', '~> 1.0.0'
gem 'sidekiq', '< 5' # Background jobs
gem 'devise-async' # Performs many devise tasks in the background using Sidekiq
gem 'sinatra', require: nil # Required for sidekiq's dashboard
gem 'seedbank' # Support for multiple seed files and their ordering
gem 'oj' # Faster JSON implementation
gem 'faker' # Fake seed data easily
gem 'active_model_serializers' # Serializes your models in a string a format
gem 'devise_token_auth' # JWT tokens for auth
gem 'firebase_token_generator' # Generate auth tokens
gem 'firebase' # Used for realtime messaging in mobile app
gem 'houston' # Apple push notifications
gem 'gcm' # Android push notifications
gem 'bower-rails', '~> 0.10.0' # Bower integration with Rails
gem 'clockwork' # Schedule recurring jobs
gem 'pismo' # Extracts metadata from an URL
gem 'active_link_to' # Automatically add an active class to current nav link
gem 'paperclip', '~> 4.3' # Handle attachments for models and forms
gem 'aws-sdk', '< 2.0' # The official AWS SDK
gem 'kaminari' # Pagination
gem 'jquery-datatables-rails' # Datatables
gem 'ajax-datatables-rails' # Adds AJAX routes for datatables queries
gem 'elasticsearch-model', '~> 0.1'
gem 'elasticsearch-rails', '~> 0.1'
gem 'sprockets', '>= 3.0.0'
gem 'sprockets-es6'
gem 'awesome_print' # Better pp
gem 'yam' # Yammer ruby SDK
gem 'httparty', '~> 0.13' # HTTP request library
gem 'liquid' # Templating engine used for email templates
gem 'autoprefixer-rails' # Automatically adds vendor prefixes to CSS declarations
gem 'fog' # AWS SDK
gem 'validate_url' # Active Model validation for URLs
gem 'omniauth-linkedin-oauth2' # OAuth for LinkedIn
gem 'omniauth-oauth2', '1.3.1' # Temporary fix to address: https://github.com/decioferreira/omniauth-linkedin-oauth2/issues/28
gem 'activerecord-import' # Adds a faster way to INSERT multiple rows in the DB
gem 'inline_svg' # Extract SVG files' content into the HTML
gem 'pundit' # Authorization
gem 'draper' # Decorators for views
gem 'daemons' # For capistrano-clockwork
gem 'icalendar' # For exporting events to your calendar

group :development, :test do
  gem 'spring', '~> 1.6.2' # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'guard-livereload', '~> 2.4', require: false
  gem 'rb-readline'
  gem 'rack-livereload'
  # The 3 gems above are for livereloading your code
  gem 'quiet_assets' # Silences asset logs
  gem 'active_record_query_trace' # View which line is making each SQL query in the logs
  gem 'rspec-rails', '~> 3.0' # Testing framework
  gem 'factory_girl_rails' # Create mock objects for testing
  gem 'capybara' # Helpers for feature specs
  gem 'poltergeist' # Allows support for JS in feature specs
  gem 'database_cleaner' # Necessary to clean the DB between tests
  gem 'pry-rails' # Better Rails console
  gem 'pry-theme' # Themes for pry

  gem 'byebug' # Debugger
end

gem 'rspec_junit_formatter', '~> 0.2.3', group: :test # Formats tests for CircleCI

group :development do
  gem 'capistrano'
  gem 'capistrano3-puma'
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rvm'
  gem 'capistrano-bower'
  gem 'capistrano-rails-console'
  gem 'capistrano-sidekiq'
  gem 'capistrano-clockwork'
  gem 'spring-commands-rspec'
  gem 'better_errors' # Different error page
  gem 'binding_of_caller'
  gem 'bullet' # Detects N+1 queries
  gem 'parallel_tests'
  gem 'meta_request' # Necessary for rails_panel Chrome extension
  # gem 'flamegraph'
  # gem 'rack-mini-profiler'
  # gem 'stackprof'
end

group :production do
  gem 'syslogger', '~> 1.6.0' # Log to syslog, which is then sent to Loggly
  gem 'lograge', '~> 0.3'
  gem 'appsignal'
  gem 'newrelic_rpm'
end
